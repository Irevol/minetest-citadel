local data = minetest.get_mod_storage()

--foward stone
minetest.register_craftitem("citadel_core:" .. "foward_stone", {
	description = "Stone of the Future",
	inventory_image = "small_stone.png^(foward_overlay.png^[colorize:black)",
	stack_max = 1,
	_citadel_inv_slot = 2,
	on_use = function(itemstack, user, pointed_thing)
		if citadel.go_foward() then
			local inv = user:get_inventory()
			local index = user:get_wield_index()
			inv:set_stack("main", user:get_wield_index(), "citadel_core:" .. "foward_stone_active")
			minetest.after(1, function(user, index)
				inv:set_stack("main", index, "citadel_core:" .. "foward_stone")
			end, user, index)
		end
	end,
})
minetest.register_craftitem("citadel_core:" .. "foward_stone_active", {
	description = "Stone of the Future",
	inventory_image = "small_stone.png^foward_overlay.png",
	stack_max = 1,
	_citadel_inv_slot = 2,
})
minetest.register_node("citadel_core:" .. "foward_stone_node", {
	description = "fsn",
	tiles = { "small_stone.png^(foward_overlay.png^[colorize:black)" },
	groups = { cracky = 2, sparkle = 1, breakable = 1, unique = 1 },
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	drop = "citadel_core:" .. "foward_stone",
	_citadel_inv_slot = 2,
	_on_unique = citadel.unique_item("citadel_core:" .. "foward_stone", "citadel_core:" .. "foward_stone_active"),
})
--backward stone
minetest.register_craftitem("citadel_core:" .. "backward_stone", {
	description = "Stone of the Past",
	inventory_image = "small_stone.png^(backward_overlay.png^[colorize:black)",
	stack_max = 1,
	_citadel_inv_slot = 1,
	on_use = function(itemstack, user, pointed_thing)
		if citadel.go_backward() then
			local inv = user:get_inventory()
			local index = user:get_wield_index()
			inv:set_stack("main", user:get_wield_index(), "citadel_core:" .. "backward_stone_active")
			minetest.after(1, function(user, index)
				inv:set_stack("main", index, "citadel_core:" .. "backward_stone")
			end, user, index)
		end
	end,
})
minetest.register_craftitem("citadel_core:" .. "backward_stone_active", {
	description = "Stone of the Past",
	inventory_image = "small_stone.png^(backward_overlay.png)",
	stack_max = 1,
	_citadel_inv_slot = 1,
})
minetest.register_node("citadel_core:" .. "backward_stone_node", {
	description = "bsn",
	tiles = { "small_stone.png^(backward_overlay.png^[colorize:black)" },
	groups = { cracky = 2, sparkle = 1, breakable = 1, unique = 1 },
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	drop = "citadel_core:" .. "backward_stone",
	_citadel_inv_slot = 1,
	_on_unique = citadel.unique_item("citadel_core:" .. "backward_stone", "citadel_core:" .. "backward_stone_active"),
})
--unlock stone

local barpref = "xpanes:bar"
local function unbar(pos)
	local node = minetest.get_node(pos)
	if node.name:sub(1, #barpref) ~= barpref then
		return
	end
	minetest.remove_node(pos)

	-- breaking bar effects
	minetest.add_particlespawner({
		amount = 50,
		time = 0.05,
		collisiondetection = true,
		collision_removal = false,
		object_collision = false,
		vertical = false,
		node = { name = node.name },
		minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z - 0.5 },
		maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
		minvel = { x = -2, y = 0.1, z = -2 },
		maxvel = { x = 2, y = 1, z = 2 },
		minacc = { x = 0, y = -9.81, z = 0 },
		maxacc = { x = 0, y = -9.81, z = 0 },
		minsize = 0.25,
		maxsize = 1,
		minexptime = 0.5,
		maxexptime = 1,
	})
	minetest.sound_play("unbarring", {
		pos = pos,
		pitch = math.random() / 10 + 0.95,
		time_start = math.random() / 5,
	}, true)

	-- magic sparkles
	minetest.add_particlespawner({
		amount = 15,
		time = 3,
		collisiondetection = false,
		collision_removal = false,
		object_collision = false,
		vertical = false,
		texture = "blue_particle.png",
		glow = 10,
		minpos = { x = pos.x - 0.5, y = pos.y - 0.5, z = pos.z - 0.5 },
		maxpos = { x = pos.x + 0.5, y = pos.y + 0.5, z = pos.z + 0.5 },
		minvel = { x = 0, y = 0.1, z = 0 },
		maxvel = { x = 0, y = 1, z = 0 },
	})

	unbar(vector.offset(pos, 0, 1, 0))
	unbar(vector.offset(pos, 0, -1, 0))
	unbar(vector.offset(pos, 1, 0, 0))
	unbar(vector.offset(pos, -1, 0, 0))
	unbar(vector.offset(pos, 0, 0, 1))
	unbar(vector.offset(pos, 0, 0, -1))
	return true
end

minetest.register_craftitem("citadel_core:" .. "unlock_stone", {
	description = "Stone of Unbarring",
	inventory_image = "small_stone.png^(unlock.png^[colorize:black)",
	stack_max = 1,
	_citadel_inv_slot = 3,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" and unbar(pointed_thing.under) then
			local inv = user:get_inventory()
			local index = user:get_wield_index()
			inv:set_stack("main", user:get_wield_index(), "citadel_core:" .. "unlock_stone_active")
			minetest.after(1, function(user, index)
				inv:set_stack("main", index, "citadel_core:" .. "unlock_stone")
			end, user, index)
		end
	end,
})
minetest.register_craftitem("citadel_core:" .. "unlock_stone_active", {
	description = "Stone of Unsealing",
	inventory_image = "small_stone.png^(unlock.png)",
	stack_max = 1,
	_citadel_inv_slot = 3,
})
minetest.register_node("citadel_core:" .. "unlock_stone_node", {
	description = "usn",
	tiles = { "small_stone.png^(unlock.png^[colorize:black)" },
	groups = { cracky = 2, sparkle = 1, breakable = 1, unique = 1 },
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	drop = "citadel_core:" .. "unlock_stone",
	_citadel_inv_slot = 3,
	_on_unique = citadel.unique_item("citadel_core:" .. "unlock_stone", "citadel_core:" .. "unlock_stone_active"),
})

--break stone
minetest.register_craftitem("citadel_core:" .. "break_stone", {
	description = "Stone of Destruction",
	inventory_image = "small_stone.png^(break.png^[colorize:black)",
	stack_max = 1,
	_citadel_inv_slot = 4,
	on_use = function(itemstack, user, pointed_thing)
		if
			pointed_thing.type == "object"
			and pointed_thing.ref:get_pos().z == citadel.crystal_pos.z
			and pointed_thing.ref:get_pos().x == citadel.crystal_pos.x
		then
			pointed_thing.ref:remove()
			minetest.add_particlespawner({
				amount = 200,
				time = 0.5,
				collisiondetection = false,
				collision_removal = false,
				object_collision = false,
				vertical = false,
				texture = "blue_particle.png",
				glow = 10,
				--these are legacy, sorry i can't figure out the new stuff
				minpos = citadel.crystal_pos,
				maxpos = citadel.crystal_pos,
				minvel = { x = -5, y = 0, z = -5 },
				maxvel = { x = 5, y = 0, z = 5 },
			})
			citadel.endgame()
		end
	end,
})
minetest.register_node("citadel_core:" .. "break_stone_node", {
	description = "dsn",
	tiles = { "small_stone.png^(break.png^[colorize:black)" },
	groups = { cracky = 2, sparkle = 1, breakable = 1, unique = 1 },
	drawtype = "signlike",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	drop = "citadel_core:" .. "break_stone",
	_on_unique = citadel.unique_item("citadel_core:" .. "break_stone"),
})
