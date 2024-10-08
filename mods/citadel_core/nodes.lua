local data = minetest.get_mod_storage()

citadel.register_node("darkstonebricks")
citadel.register_node("darkstonecarved")
citadel.register_node("darkstonetile")
citadel.register_node("mossydarkstonebricks")

citadel.register_node("whitestonebricks")
citadel.register_node("whitestonecarved")
citadel.register_node("whitestonetile")
citadel.register_node("mossywhitestonebricks")

citadel.register_node("stonebricks")
citadel.register_node("stonecarved")
citadel.register_node("stonetile")
citadel.register_node("mossystonebricks")

citadel.register_node("wood", "woody")
citadel.register_node("plaster")
citadel.register_node("grass", "grassy")
citadel.register_node("grasswithstones", "grassy")
citadel.register_node("alt_stonetile")
citadel.register_node("trunk", "woody")

minetest.register_alias("citadel_core:" .. "default_leaves", "citadel_core:" .. "leaves")
minetest.register_node("citadel_core:" .. "leaves", {
	description = "leaves",
	tiles = { "leaves.png" },
	drawtype = "allfaces_optional",
	use_texture_alpha = "clip",
	groups = { cracky = 2 },
	sounds = citadel.nodecore_sounds("swishy"),
})
minetest.register_node("citadel_core:" .. "stone", {
	description = "stonewithgrass",
	tiles = { "stone.png^[colorize:#000000:80" },
	groups = { cracky = 2 },
	sounds = citadel.nodecore_sounds("stony"),
})
minetest.register_node("citadel_core:" .. "stone_cracked", {
	description = "cracked stone",
	tiles = { "(stone.png^cracks.png)^[colorize:#000000:40" },
	groups = { cracky = 2 },
	sounds = citadel.nodecore_sounds("stony"),
})
minetest.register_node("citadel_core:" .. "small_wood", {
	description = "small trunk",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = { -2 / 16, -0.5, -2 / 16, 2 / 16, 0.5, 2 / 16 },
	},
	tiles = { "trunk.png" },
	groups = { cracky = 2 },
	paramtype = "light",
	sunlight_propagates = true,
	sounds = citadel.nodecore_sounds("woody"),
})
local stonetex = "stone.png^[colorize:#000000:80"
minetest.register_node("citadel_core:" .. "stonewithgrass", {
	description = "stonewithgrass",
	tiles = {
		"grass.png",
		"grass.png",
		stonetex .. "^grass_overlay.png",
		stonetex .. "^grass_overlay.png",
		stonetex .. "^grass_overlay.png",
		stonetex .. "^grass_overlay.png",
	},
	groups = { cracky = 2 },
	sounds = citadel.nodecore_sounds("grassy"),
})
minetest.register_node("citadel_core:" .. "black", {
	description = "black",
	tiles = { "civ_white.png^[colorize:#000000" },
	groups = { cracky = 2 },
	paramtype = "light",
	light_source = 14,
})
minetest.register_node("citadel_core:" .. "trigger", {
	description = "trigger",
	drawtype = "airlike",
	groups = { cracky = 2 },
	pointable = false,
	sunlight_propagates = true,
	walkable = false,
	on_timer = function(pos)
		local objs = minetest.get_objects_inside_radius(pos, 0.9)
		for _, obj in pairs(objs) do
			if obj:get_player_name() == "singleplayer" then
				local img = "title.png^[colorize:#ffffff:50"
				img = citadel.shadow(img, 256, 144, 1)
				citadel.hud("title", img, 4)
				minetest.set_node(pos, { name = "air" })
				return false
			end
		end
		return true
	end,
})

for i = 1, 12 do
	minetest.register_node("citadel_core:" .. "stone_with_glyph_" .. i, {
		description = "stone with glyph " .. i,
		tiles = { "stone.png^glyph" .. i .. ".png" },
		groups = { cracky = 2 },
		sounds = citadel.nodecore_sounds("stony"),
	})
end

local function collectable_chime(pos)
	for i = 0, 9 do
		local offs = i / 10
		minetest.sound_play("chime", {
			pos = vector.add(pos, vector.new(
				math.random() * 20 - 10,
				math.random() * 20 - 10,
				math.random() * 20 - 10
			)),
			start_time = offs,
			gain = 1 - offs
		}, true)
	end
end

--colectables
local function register_collectable(name, desc)
	minetest.register_craftitem("citadel_core:" .. name, {
		description = desc,
		inventory_image = name .. ".png",
		stack_max = 1,
	})
	minetest.register_node("citadel_core:" .. name .. "_node", {
		description = desc .. " node",
		inventory_image = name .. ".png",
		tiles = { name .. ".png" },
		groups = { cracky = 2, breakable = 1, sparkle = 1, unique = 1 },
		drawtype = "signlike",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		drop = "",
		selection_box = {
			type = "wallmounted",
		},
		after_dig_node = collectable_chime,
		_on_unique = citadel.unique_item("citadel_core:" .. name .. "_node"),
	})
end
register_collectable("pendant", "Ancient Pendant")
register_collectable("tablet", "Ancient Tablet")
register_collectable("amulet", "Ancient Amulet")
register_collectable("sigil", "Ancient Sigil")
register_collectable("scepter", "Ancient Scepter")
register_collectable("coin", "Ancient Coin")
register_collectable("totem", "Oddly Shaped Totem")

minetest.register_on_dignode(function(pos, oldnode, digger)
	digger:get_meta():set_string(oldnode.name, "obtained")
	digger:get_meta():set_string("last_dug", oldnode.name)
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	placer:get_meta():set_string(newnode.name, "")
end)

minetest.register_abm({
	label = "Uniqueness Check",
	nodenames = { "group:unique" },
	interval = 1,
	chance = 1,
	action = function(pos, node)
		node = node or minetest.get_node(pos)
		local def = minetest.registered_nodes[node.name]
		if def and def._on_unique then
			def._on_unique(pos, node)
		end
	end,
})

--sparkle abm
minetest.register_abm({
	label = "Sparkles",
	nodenames = { "group:sparkle" },
	interval = 3,
	chance = 1,
	min_y = -200,
	max_y = 200,
	action = function(pos, node, active_object_count, active_object_count_wider)
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
	end,
})
--trigger lbm
minetest.register_lbm({
	label = "trigger",
	name = "citadel_core:" .. "triggerlbm",
	nodenames = { "citadel_core:" .. "trigger" },
	run_at_every_load = true,
	action = function(pos, node, dtime_s)
		minetest.get_node_timer(pos):start(0.1)
	end,
})

minetest.register_alias("citadel_core:" .. "star", "air")
