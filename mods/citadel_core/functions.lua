

function citadel.change_time_period(time_period)

	--minetest.chat_send_all(minetest.serialize(time_period))
	minetest.place_schematic({x=0,y=0,z=0}, minetest.get_modpath("citadel_core").."/schems/"..citadel.schems[time_period], nil, nil, true, nil)
	data:set_int("time_period", time_period)
	
	--ghost
	minetest.clear_objects()
	if data:get_string("ended") == "" then
		for _, ghost in pairs(citadel.ghost_data) do
			-- {time period,pos,images}
			if ghost[1] == time_period then
				--minetest.chat_send_all("gg")
				gobj = minetest.add_entity(ghost[2], cc.."ghost", minetest.serialize(ghost[3]))
				gobj:set_properties({_images = minetest.serialize(ghost[3])})
			end
		end
		--crystal
		minetest.add_entity(citadel.crystal_pos, cc.."crystal")
	end

	--sepia
	local player = minetest.get_player_by_name("singleplayer")
	local id = data:get_int("sepia_hud_id")
	player:hud_change(id, "text", "sepia.png^[opacity:".. 15*(5-time_period))
	
	local plant_data = minetest.deserialize(data:get_string("plant_data"))
	
	--plants
	for _, plant in pairs(plant_data) do
		local pos = plant[1]
		local plant_type = plant[2]
		--how "long" has this been planted for
		local plant_time = time_period-plant[3]
		
		--this hasn't been planted yet!
		if plant_time >= 0 then 	
			if plant_type == "tree" then
				--minetest.chat_send_all("ggg")
				pos.y = pos.y-1
				while minetest.get_node(pos).name == "air" do
					pos.y = pos.y-1
				end
				pos.y = pos.y+1
				if plant_time == 0 then
					minetest.set_node(pos, {name = cc.."acorn"})
				else
					local schems = {"tree1.mts","tree2.mts","tree3.mts","tree4.mts"}
					minetest.place_schematic(pos, minetest.get_modpath("citadel_core").."/schems/"..schems[plant_time], nil, nil, true, {place_center_x=true, place_center_z=true})
				end
			end
			
			if plant_type == "big_tree" then
				pos.y = pos.y-1
				while minetest.get_node(pos).name == "air" do
					pos.y = pos.y-1
				end
				pos.y = pos.y+1
				if plant_time == 0 then
					minetest.set_node(pos, {name = cc.."big_acorn"})
				else
					local schems = {"tree2.mts","tree3.mts","tree4.mts","tree4.mts"}
					minetest.place_schematic(pos, minetest.get_modpath("citadel_core").."/schems/"..schems[plant_time], nil, nil, true, {place_center_x=true, place_center_z=true})
				end
			end
			
			if plant_type == "vine" then
				pos.y = pos.y+1
				if minetest.get_node(pos).name ~= "air" then
					pos.y = pos.y-1
					if plant_time == 0 then
						minetest.set_node(pos, {name = cc.."vine_bud"})
					end
					local terminate = false
					for i=0,plant_time do
						if not terminate then
							pos.y = pos.y-i
							if minetest.get_node(pos).name ~= "air" then
								terminate = true
							else
								minetest.set_node(pos, {name = cc.."vine"})
							end
							pos.y = pos.y+i
						end
					end
				end
			end
			
			if plant_type == "bamboo" then
				pos.y = pos.y-1
				while minetest.get_node(pos).name == "air" do
					pos.y = pos.y-1
				end
				pos.y = pos.y+1
				if plant_time == 0 then
					minetest.set_node(pos, {name = cc.."bamboo_shoot"})
				end
				local terminate = false
				for i=0,(plant_time*2) do
					if not terminate then
						pos.y = pos.y+i
						if minetest.get_node(pos).name ~= "air" then
							terminate = true
						else
							minetest.set_node(pos, {name = cc.."bamboo"})
						end
						pos.y = pos.y-i
					end
				end
			end
		end
		
		-- if plant_type == "red_mushroom" then
			-- if plant_time = 1 then
				-- minetest.set_node(pos, {name = "red_mushroom"})
			-- elseif plant_time > 1 then
				-- for z=-1,1,2 do
					-- pos.z=pos.z+z
					-- minetest.set_node(pos, {name = "air"})
					-- pos.z=pos.z-z
				-- end
				-- for x=-1,1,2 do
					-- pos.x=pos.x+x
					-- minetest.set_node(pos, {name = "air"})
					-- pos.x=pos.x-x
				-- end
			-- end
		-- end

		-- Search for "unique" nodes and make sure duplicates do
		-- not exist after the time period has been fully loaded.
		for _, pos in pairs(minetest.find_nodes_in_area(
			vector.new(0, 0, 0),
			vector.new(45, 32, 43),
			"group:unique")) do
			local node = minetest.get_node(pos)
			local def = minetest.registered_nodes[node.name]
			if def and def._on_unique then
				def._on_unique(pos, node)
			end
		end
	end
end

function citadel.record_plant(pos, plant_type)
	local plant_data = minetest.deserialize(data:get_string("plant_data"))
	table.insert(plant_data, {pos, plant_type, data:get_int("time_period")})
	data:set_string("plant_data", minetest.serialize(plant_data))
end

function citadel.unrecord_plant(pos, plant_type)
	local plant_data = minetest.deserialize(data:get_string("plant_data"))
	for i, plant in pairs(plant_data) do
	    if plant[1].x == pos.x and plant[1].y == pos.y and plant[1].z == pos.z and plant[2] == plant_type then
			table.remove(plant_data, i)
			data:set_string("plant_data", minetest.serialize(plant_data))
			break
	    end
	end
end

function citadel.check_player_collided(player)
	local pos = player:get_pos()
	for dy = 0, 1.9 do
		for dx = -0.3, 0.3, 0.6 do
			for dz = -0.3, 0.3, 0.6 do
				local p = vector.offset(pos, dx, dy, dz)
				if minetest.get_node(p).name ~= "air" then return true end
			end
		end
	end
end

-- lua has no +=? what? IKR
function citadel.go_foward()
	local time_period = data:get_int("time_period")
	time_period = time_period+1
	if time_period > 5 then
		return false
	end
	citadel.hud("flash", "flash.png", 0.1, 0.05)
	minetest.after(0.5, function(time_period)
		citadel.change_time_period(time_period)
		if citadel.check_player_collided(minetest.get_player_by_name("singleplayer")) then
			citadel.change_time_period(time_period-1)
		end
	end, time_period)
	minetest.sound_play("travel", {to_player = "singleplayer"}, true)
	return true
end

function citadel.go_backward()
	local time_period = data:get_int("time_period")
	time_period = time_period-1
	if time_period < 1 then
		return false
	end
	citadel.hud("flash", "flash.png", 0.1, 0.05)
	minetest.after(0.5, function(time_period)
		citadel.change_time_period(time_period)
		if citadel.check_player_collided(minetest.get_player_by_name("singleplayer")) then
			citadel.change_time_period(time_period+1)
			--minetest.civ.highlight("No")
		end
	end, time_period)
	minetest.sound_play("travel", {to_player = "singleplayer"}, true)
	return true
end

function citadel.register_node(name)
	minetest.register_node(cc..name, {
		description = name,
		tiles = {name..".png"},
		groups = {cracky=2},
	})
	minetest.register_node(cc..name.."_cracked", {
		description = name.." cracked",
		tiles = {name..".png^cracks.png"},
		groups = {cracky=2},
	})
end

local huds = {}
local function processhud(player, key, hud)
	local totaltime = hud.wait + hud.fadetime * 2
	if hud.time >= totaltime then
		if hud.id then player:hud_remove(hud.id) end
		huds[key] = nil
		return
	end

	local opacity = 1
	if hud.time < hud.fadetime then
		opacity = hud.time / hud.fadetime
	elseif hud.time > totaltime - hud.fadetime then
		opacity = (totaltime - hud.time) / hud.fadetime
	end
	local image
	local alpha = math.ceil(opacity * 16) * 16
	if alpha <= 0 then
		image = "blank.png"
	elseif alpha >= 255 then
		image = hud.image
	else
		image = hud.image .. "^[opacity:" .. alpha
	end

	if not hud.id then
		hud.id = player:hud_add({
			hud_elem_type = "image",
			position = {x=0.5, y=0.5},
			-- Top left corn2er position of element
			name = "image",
			scale = {x = -100, y = -100},
			text = image,
			direction = 0,
			-- Direction: 0: left-right, 1: right-left, 2: top-bottom, 3: bottom-top
			alignment = {x=0, y=0},
			offset = {x=0, y=0},
			z_index = 100,
			-- Z index: lower z-index HUDs are displayed behind higher z-index HUDs
			style = 2,
		})
		hud.displayed = image
	elseif image ~= hud.displayed then
		player:hud_change(hud.id, "text", image)
		hud.displayed = image
	end
end
minetest.register_globalstep(function(dtime)
	local player = minetest.get_player_by_name("singleplayer")
	for key, hud in pairs(huds) do
		hud.time = hud.time + dtime
		processhud(player, key, hud)
	end
end)

function citadel.hud(key, image, wait, rate)
	local old = huds[key]
	if old and old.id then
		-- Move immediate fade-out to a new
		-- entry that always has a new unique key
		huds[{}] = old.time >= (old.wait + old.fadetime)
		and old -- if already fading, keep fading
		or {
			id = old.id,
			time = old.fadetime,
			image = old.image,
			fadetime = old.fadetime,
			wait = 0
		}
	end
	huds[key] = {
		time = 0,
		image = image,
		wait = wait or 2,
		fadetime = rate and rate * 10 or 1
	}
end

local function txresc(s)
	return s:gsub("\\", "\\\\"):gsub("%^", "\\^"):gsub(":", "\\:")
end
function citadel.shadow(image, w, h, offset, alpha)
	offset = offset or 2
	alpha = alpha or 64
	local shad = txresc(image .. "^[multiply:#000000FF^[opacity:" .. alpha)
	local t = {"[combine:" .. (w + offset * 2) .. "x" .. (h + offset * 2)}
	for dx = 0, offset * 2, offset do
		for dy = 0, offset * 2, offset do
			if dx ~= offset or dy ~= offset then
				t[#t + 1] = dx .. "," .. dy .. "=" .. shad
			end
		end
	end
	t[#t + 1] = offset .. "," .. offset .. "=" .. txresc(image)
	print(table.concat(t, ":"))
	return table.concat(t, ":")
end

function citadel.endgame()
	--citadel.change_time_period(time_period)
	local player = minetest.get_player_by_name("singleplayer")
	citadel.hud("white", "white_hud.png")
	data:set_string("endpos", minetest.serialize(player:get_pos()))
	minetest.place_schematic({x=0,y=-50,z=0}, minetest.get_modpath("citadel_core").."/schems/endroom.mts", nil, nil, true, nil)
	minetest.add_entity({x=10,y=-47,z=10}, cc.."ghost", minetest.serialize({50}))
	minetest.after(1, function(player) player:set_pos({x=2,y=-40,z=2}) end, player)
	minetest.after(2, function(player) player:set_pos({x=3,y=-40,z=3}) end, player)
	data:set_string("ended", "yes")
	minetest.sound_play("crack", {to_player = "singleplayer"}, true)
end

function citadel.unique_item(...)
	local items = {...}
	for i = 1, #items do items[i] = ItemStack(items[i]) end
	return function(pos)
		local inv = minetest.get_player_by_name("singleplayer"):get_inventory()
		for i = 1, #items do
			if inv:contains_item("main", items[i], false) then
				return minetest.remove_node(pos)
			end
		end
	end
end