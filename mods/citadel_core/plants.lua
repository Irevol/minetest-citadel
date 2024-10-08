local data = minetest.get_mod_storage()
local strength = "230"
local green = "civ_white.png^[colorize:#4d9655:" .. strength
local dark_green = "civ_white.png^[colorize:#0a3d05:" .. strength
local dark_brown = "civ_white.png^[colorize:#3c1904:" .. strength
local brown = "civ_white.png^[colorize:#9d5019:" .. strength

local plantsound = {
	footstep = {
		name = "plantcrackle",
		gain = 0.5
	},
	dug = {
		name = "plantcrackle",
	},
	place = {
		name = "plantcrackle",
	},
}

minetest.register_node("citadel_core:" .. "acorn", {
	description = "Acorn",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	mesh = "acorn.obj",
	walkable = false,
	tiles = { brown, dark_brown },
	sounds = plantsound,
	groups = { cracky = 2, breakable = 1, unique = 1 },
	_citadel_inv_slot = 6,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		pos.y = pos.y - 1
		if
			minetest.get_node(pos).name == "air"
			or minetest.get_item_group(minetest.get_node(pos).name, "breakable") ~= 0
		then
			pos.y = pos.y + 1
			minetest.set_node(pos, { name = "air" })
			return true
		end
		pos.y = pos.y + 1
		citadel.record_plant(pos, "tree")
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		citadel.unrecord_plant(pos, "tree")
	end,
	_on_unique = citadel.unique_item("citadel_core:" .. "acorn"),
})

minetest.register_node("citadel_core:" .. "big_acorn", {
	description = "Big Acorn",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	mesh = "big_acorn.obj",
	walkable = false,
	tiles = { brown, dark_brown },
	sounds = plantsound,
	groups = { cracky = 2, breakable = 1, unique = 1 },
	_citadel_inv_slot = 5,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		pos.y = pos.y - 1
		if
			minetest.get_node(pos).name == "air"
			or minetest.get_item_group(minetest.get_node(pos).name, "breakable") ~= 0
		then
			pos.y = pos.y + 1
			minetest.set_node(pos, { name = "air" })
			return true
		end
		pos.y = pos.y + 1
		citadel.record_plant(pos, "big_tree")
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		citadel.unrecord_plant(pos, "big_tree")
	end,
	_on_unique = citadel.unique_item("citadel_core:" .. "big_acorn"),
})

minetest.register_node("citadel_core:" .. "vine_bud", {
	description = "Vine Bud",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	mesh = "bud.obj",
	tiles = { green },
	sounds = plantsound,
	walkable = false,
	groups = { cracky = 2, breakable = 1, unique = 1 },
	_citadel_inv_slot = 8,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		pos.y = pos.y + 1
		if
			minetest.get_node(pos).name == "air"
			or minetest.get_item_group(minetest.get_node(pos).name, "breakable") ~= 0
		then
			pos.y = pos.y - 1
			minetest.set_node(pos, { name = "air" })
			return true
		end
		pos.y = pos.y - 1
		citadel.record_plant(pos, "vine")
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		citadel.unrecord_plant(pos, "vine")
	end,
	_on_unique = citadel.unique_item("citadel_core:" .. "vine_bud"),
})
minetest.register_node("citadel_core:" .. "vine", {
	description = "Vine",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	climbable = true,
	walkable = false,
	mesh = "vine.obj",
	tiles = { green, dark_green },
	sounds = plantsound,
	groups = { cracky = 2 },
})
minetest.register_node("citadel_core:" .. "bamboo_shoot", {
	description = "Bamboo Shoot",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	mesh = "bamboo_shoot.obj",
	walkable = false,
	tiles = { dark_green },
	sounds = plantsound,
	groups = { cracky = 2, breakable = 1, unique = 1 },
	_citadel_inv_slot = 7,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		pos.y = pos.y - 1
		if
			minetest.get_node(pos).name == "air"
			or minetest.get_item_group(minetest.get_node(pos).name, "breakable") ~= 0
		then
			pos.y = pos.y + 1
			minetest.set_node(pos, { name = "air" })
			return true
		end
		pos.y = pos.y + 1
		citadel.record_plant(pos, "bamboo")
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		citadel.unrecord_plant(pos, "bamboo")
	end,
	_on_unique = citadel.unique_item("citadel_core:" .. "bamboo_shoot"),
})
minetest.register_node("citadel_core:" .. "bamboo", {
	description = "Bamboo",
	drawtype = "mesh",
	sunlight_propagates = true,
	paramtype = "light",
	mesh = "bamboo.obj",
	tiles = { dark_green },
	sounds = plantsound,
	groups = { cracky = 2 },
})
--NOT ENOUGH TIME AAAAAAAAAHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
-- minetest.register_node("citadel_core:".."mushroom", {
-- description = "Mushroom Spore"
-- drawtype = "mesh",
-- sunlight_propagates = true,
-- paramtype = "light",
-- mesh = "mushroom.obj",
-- tiles = {},
-- groups = {cracky=2},
-- after_place_node = function(pos, placer, itemstack, pointed_thing)
-- local found = false
-- pos.x = pos.x-1
-- if minetest.get_node(pos).name == "" then found = true end
-- pos.x = pos.x+2
-- if minetest.get_node(pos).name == "" then found = true end
-- pos.x = pos.x-1
-- pos.z=pos.z-1
-- if minetest.get_node(pos).name == "" then found = true end
-- pos.z=pos.z+2
-- if minetest.get_node(pos).name == "" then found = true end
-- pos.z = pos.z-1
-- if found then
-- minetest.set_node(pos, {name = "air"})
-- return true
-- end
-- citadel.record_plant(pos, "mushroom")
-- end,
-- after_dig_node = function(pos, oldnode, oldmetadata, digger)
-- citadel.unrecord_plant(pos, "mushroom")
-- end
-- })
