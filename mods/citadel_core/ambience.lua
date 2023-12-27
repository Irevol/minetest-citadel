local ambiance_handle
local saved_id

local ducking
function citadel.audio_duck(time)
	if not ambiance_handle then return end
	local my_ducking = {}
	ducking = my_ducking
	minetest.sound_fade(ambiance_handle, 1, citadel.sounds[saved_id].gain / 5)
	minetest.after(time, function()
		if my_ducking ~= ducking then return end -- replaced by another duck
		minetest.sound_fade(ambiance_handle, 0.2, citadel.sounds[saved_id].gain)
	end)
end

local start_time = 0
minetest.register_globalstep(function(dtime)
	start_time = start_time + dtime
	-- Minetest doesn't like music start_time arbitrarily large
	if start_time >= 864000 then start_time = start_time - 864000 end
end)

--minetest.sound_play(spec, parameters, [ephemeral])
--minetest.sound_fade(handle, step, gain)
function citadel.set_ambience(id)
	saved_id = id
	if ambiance_handle then
		minetest.sound_fade(ambiance_handle, 0.2, 0)
	end
	ambiance_handle = minetest.sound_play(citadel.sounds[id].file, {
		to_player = "singleplayer",
		gain = citadel.sounds[id].gain,
		fade = 0.2,
		pitch = 1.0,
		loop = true,
		start_time = citadel.sounds[id].offset and start_time or 0
	}, false)
end

minetest.register_on_joinplayer(function(ObjectRef, last_login)
	citadel.set_ambience(1)
end)