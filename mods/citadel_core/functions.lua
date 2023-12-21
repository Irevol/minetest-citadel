

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
				minetest.add_entity(ghost[2], cc.."ghost", minetest.serialize(ghost[3]))
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

-- lua has no +=? what?
function citadel.go_foward()
	local time_period = data:get_int("time_period")
	time_period = time_period+1
	if time_period > 5 then
		return false
	end
	citadel.hud("flash.png", 0.1, 10, 0.5, 0.05)
	minetest.after(0.5, function(time_period)
		citadel.change_time_period(time_period)
		if minetest.get_node(minetest.get_player_by_name("singleplayer"):get_pos()).name ~= "air" then 
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
	citadel.hud("flash.png", 0.1, 10, 0.5, 0.05)
	minetest.after(0.5, function(time_period)
		citadel.change_time_period(time_period)
		if minetest.get_node(minetest.get_player_by_name("singleplayer"):get_pos()).name ~= "air" then 
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

function citadel.hud(image, wait, scale, ypos, interval)
	if not scale then
		scale = 10
	end
	if not wait then
		wait = 2
	end
	if not interval then
		interval = 0.025
	end
	if not ypos then
		ypos = 0.5
	end
	local player = minetest.get_player_by_name("singleplayer")
	local hud_id = player:hud_add({
		hud_elem_type = "image",
		position = {x=0.5, y=ypos},
		-- Top left corner position of element
		name = "image",
		scale = {x = scale, y = scale},
		text = image.."^[opacity:0";
		direction = 0,
		-- Direction: 0: left-right, 1: right-left, 2: top-bottom, 3: bottom-top
		alignment = {x=0, y=0},
		offset = {x=0, y=0},
		z_index = 100,
		-- Z index: lower z-index HUDs are displayed behind higher z-index HUDs
		style = 2,
	})
	for opacity = 0,255,interval do 
		player:hud_change(hud_id, "text", image.."^[opacity:"..opacity)
	end
	minetest.after(wait, 
	--can someone explain how to make a "sleep" function?
		function(player,hud_id)
			for opacity = 255,0,-interval do 
				player:hud_change(hud_id, "text", image.."^[opacity:"..opacity)
			end
			player:hud_remove(hud_id)
		end,
	player, hud_id)
end

function citadel.endgame()
	--citadel.change_time_period(time_period)
	local player = minetest.get_player_by_name("singleplayer")
	citadel.hud("white_hud.png")
	data:set_string("endpos", minetest.serialize(player:get_pos()))
	minetest.place_schematic({x=0,y=-50,z=0}, minetest.get_modpath("citadel_core").."/schems/endroom.mts", nil, nil, true, nil)
	minetest.add_entity({x=10,y=-47,z=10}, cc.."ghost", minetest.serialize({50}))
	minetest.after(1, function(player) player:set_pos({x=2,y=-46,z=2}) end, player)
	data:set_string("ended", "yes")
	minetest.sound_play("crack", {to_player = "singleplayer"}, true)
	citadel.set_ambience(3)
end
