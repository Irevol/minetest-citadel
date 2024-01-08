local function sepia_hud_create(player)
	citadel.sepia_hud_id = citadel.sepia_hud_id or player:hud_add({
		hud_elem_type = "image",
		position = {x=0.5, y=0.5},
		name = "sepia",
		scale = {x = 10, y = 10},
		text = "sepia.png^[opacity:".. 15*(5-data:get_int("time_period")),
		direction = 0,
		alignment = {x=0, y=0},
		offset = {x=0, y=0},
		z_index = 200,
		style = 2,
	})
end

minetest.register_on_joinplayer(function(player)
	player:set_inventory_formspec("")
	sepia_hud_create(player)
	player:set_armor_groups({
		immortal = 1,
		fall_damage_add_percent = -100
	})
	player:hud_set_flags({
		healthbar = false,
		breathbar = false,
		minimap = false,
	})
	player:set_sky({base_color ="#000000", clouds = false, sky_color={dawn_sky = "#000000", day_sky="#000000",night_sky="#000000",dawn_horizon = "#000000",night_horizon="#000000", day_horizon="#000000"}})
	player:set_physics_override({jump=1.1})
	player:set_properties({textures = {"blank.png"}})
	--make sure you don't end up with permanently activated stones
	local inv = player:get_inventory()
	for _, stone_name in pairs({"foward", "backward", "unbaring", "break"}) do
		if inv:contains_item("main", cc..stone_name.."_stone_active") then
			for i = 1,inv:get_size("main") do
				if inv:get_stack("main", i):get_name() == cc..stone_name.."_stone_active" then 
					inv:set_stack("main", i, cc..stone_name.."_stone")
				end
			end
		end
	end
	--clear away old treaure items 
	for _, artifact_name in pairs({"pendant","coin","totem","scepter","sigil","amulet","tablet"}) do
		if inv:contains_item("main", cc..artifact_name) then
			for i = 1,inv:get_size("main") do
				if inv:get_stack("main", i):get_name() == cc..artifact_name then 
					inv:set_stack("main", i, "")
					player:get_meta():set_string(cc..artifact_name.."_node", "obtained")
				end
			end
		end
	end
end)


minetest.register_on_newplayer(function(player)
	data:set_string("ended", "")
	data:set_string("plant_data", minetest.serialize({ {{x=37,y=7,z=19},"vine",3},{{x=35,y=2,z=32},"bamboo",2},{{x=3,y=2,z=19},"tree",1},{{x=43,y=1,z=2},"big_tree",3} }))
	--player:override_day_night_ratio(1)
	minetest.place_schematic({x=-9,y=-1,z=-8}, minetest.get_modpath("citadel_core").."/schems/arena.mts", nil, nil, true, nil)
	sepia_hud_create(player)
	citadel.change_time_period(5)
	player:set_pos({x=40,y=7,z=-5})
	player:get_inventory():set_stack("main",1,cc.."letter")
	player:get_inventory():set_stack("main",2,cc.."book")
	player:get_meta():set_int("page", 1)
end)

-- --from Glitch
local RESET_TIME = 5
local timer = RESET_TIME

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= RESET_TIME then
		minetest.set_timeofday(0.6)
		timer = 0
	end
end)
