
minetest.register_on_joinplayer(function(ObjectRef, last_login)
	local id = ObjectRef:hud_add({
		hud_elem_type = "image",
		position = {x=0.5, y=0.5},
		name = "sepia",
		scale = {x = 10, y = 10},
		text = "sepia.png^[opacity:0";
		direction = 0,
		alignment = {x=0, y=0},
		offset = {x=0, y=0},
		z_index = 200,
		style = 2,
	})
	data:set_int("sepia_hud_id", id)
	data:set_string("ended", "")
	data:set_string("plant_data", minetest.serialize({ {{x=37,y=7,z=19},"vine",3},{{x=35,y=2,z=32},"bamboo",2},{{x=3,y=2,z=19},"tree",1},{{x=43,y=1,z=2},"big_tree",3} }))
	--ObjectRef:override_day_night_ratio(1)
	minetest.place_schematic({x=-9,y=-1,z=-8}, minetest.get_modpath("citadel_core").."/schems/arena.mts", nil, nil, true, nil)
	citadel.change_time_period(5)
	ObjectRef:set_pos({x=40,y=7,z=-5})
	ObjectRef:set_sky({base_color ="#000000", clouds = false, sky_color={dawn_sky = "#000000", day_sky="#000000",night_sky="#000000",dawn_horizon = "#000000",night_horizon="#000000", day_horizon="#000000"}})
	ObjectRef:set_physics_override({jump=1.1})
	--ObjectRef:hud_set_flags(hud_flags)
	--citadel.hud("title.png", 4, 10)
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