local string_format, math_floor = string.format, math.floor

local modstore = minetest.get_mod_storage()

-- Keep track of the number of play sessions.
local sessions = modstore:get_int("sessions") or 0
sessions = sessions + 1
modstore:set_int("sessions", sessions)

-- Keep track of whether timer is frozen due to endgame.
local endgame = modstore:get_string("endgame")
if endgame == "" then endgame = nil end

-- Monkey-patch the ghost so that the final ghost, which starts the
-- endgame sequence, freezes the timer as soon as you talk to it.
-- This is the last meaningful control input from the player.
do
	local ghost = minetest.registered_entities["citadel_core:ghost"]
	if not ghost then error("ghost entity registration not found") end
	local oldclick = ghost.on_rightclick
	ghost.on_rightclick = function(self, ...)
		local diaid = self._images[self._image_index]
		if diaid == 50 and not endgame then
			endgame = true
			modstore:set_string("endgame", "1")
		end
		return oldclick(self, ...)
	end
end

-- Keep track of total play time.
local timer = modstore:get_float("timer") or 0

-- Stub for updating HUDs, which is enabled only if the speedrun
-- setting is enabled at startup (there is no value in supporting
-- toggling it at runtime as runs would be invalid anyway).
local function updatehuds() end
if minetest.settings:get_bool("citadel_speedrun") then
	-- Utility function to format time in sexagesimal.
	local function timefmt(n)
		local s = string_format("%0.3f", n % 60)
		if n < 60 then return s end
		if (n % 60) < 10 then s = "0" .. s end
		local m = math_floor(n / 60)
		if m < 60 then return m .. ":" .. s end
		local h = math_floor(m / 60)
		m = m % 60
		m = (m < 10) and ("0" .. m) or ("" .. m)
		return h .. ":" .. m .. ":" .. s
	end

	local huds = {}
	updatehuds = function()
		-- Show timer, with [sessions] prefixed if the number of
		-- sessions is not 1 (it should always be 1 for valid runs).
		local text = ((sessions ~= 1) and ("[" .. sessions .. "] ") or "")
		.. timefmt(timer)
		-- Add/update all player HUD text.
		for _, player in ipairs(minetest.get_connected_players()) do
			local pname = player:get_player_name()
			local hud = huds[pname]
			if not hud then
				hud = {
					id = player:hud_add({
							hud_elem_type = "text",
							position = {x = 1, y = 0},
							alignment = {x = -1, y = 1},
							offset = {x = -4, y = 4},
							text = text,
							number = 0xffffffff,
							style = 5,
							z_index = 1100
						}),
					text = text,
				}
				huds[pname] = hud
			end
			if hud.text ~= text then
				player:hud_change(hud.id, "text", text)
				hud.text = text
			end
		end
	end
	-- Invalidate HUD cache of players who leave.
	minetest.register_on_leaveplayer(function(player)
			huds[player:get_player_name()] = nil
		end)
end

-- Update timer and HUDs every step.
do
	local prevtick
	local get_us_time = minetest.get_us_time
	minetest.register_globalstep(function()
			local now = get_us_time() / 1000000
			if not prevtick then prevtick = now end
			if not endgame then
				timer = timer + now - prevtick
				prevtick = now
				modstore:set_float("timer", timer)
			end
			updatehuds()
		end)
end
