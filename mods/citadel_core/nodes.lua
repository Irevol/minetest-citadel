
-- minetest.register_node(c.."woodhouse2", {
	-- description = 
	-- drawtype = "mesh",
	-- sunlight_propagates = true,
	-- paramtype = "light",
	-- mesh = "woodhouse.obj",
	-- tiles = {"civ_wood.png", black, grey, pink, brown},
	-- groups = {cracky=2, structure=1},
	-- on_place = function(itemstack, placer, pointed_thing)
		-- if civ.is_around(pointed_thing.above, c.."forest") and civ.is_around(pointed_thing.above, c.."road") then
			-- minetest.set_node(pointed_thing.above, {name = c.."woodhouse2"})
			-- civ.change_resource_rate(c.."lumber", 0.4)
		-- else
			-- minetest.chat_send_all(error_msg)
		-- end
	-- end,
	-- on_dig = function(pos, node, digger)
		-- civ.change_resource_rate(c.."lumber", -0.4)
		-- minetest.set_node(pos, {name = "air"})
	-- end
-- })

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
citadel.register_node("default_leaves", "swishy")

minetest.register_node(cc.."stone", {
	description = "stonewithgrass",
	tiles = {"stone.png^[colorize:#000000:80"},
	groups = {cracky=2},
	sounds = citadel.nodecore_sounds("stony"),
})
minetest.register_node(cc.."stone_cracked", {
	description = "cracked stone",
	tiles = {"(stone.png^cracks.png)^[colorize:#000000:40"},
	groups = {cracky=2},
	sounds = citadel.nodecore_sounds("stony"),
})
minetest.register_node(cc.."small_wood", {
	description = "small trunk",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-2/16,-0.5,-2/16,2/16,0.5,2/16},
	},
	tiles = {"trunk.png"},
	groups = {cracky=2},
	sunlight_propagates = true,
	sounds = citadel.nodecore_sounds("woody"),
})
local stonetex = "stone.png^[colorize:#000000:80"
minetest.register_node(cc.."stonewithgrass", {
	description = "stonewithgrass",
	tiles = {"grass.png", "grass.png", stonetex.."^grass_overlay.png",stonetex.."^grass_overlay.png", stonetex.."^grass_overlay.png",stonetex.."^grass_overlay.png" },
	groups = {cracky=2},
	sounds = citadel.nodecore_sounds("grassy"),
})
minetest.register_node(cc.."black", {
	description = "black",
	tiles = {"civ_white.png^[colorize:#000000"},
	groups = {cracky=2},
	paramtype = "light",
	light_source = 14,
})
minetest.register_node(cc.."trigger", {
	description = "trigger",
	drawtype = "airlike",
	groups = {cracky=2},
	pointable = false,
	sunlight_propagates = true,
	walkable=false,
	on_timer = function(pos)
		local objs = minetest.get_objects_inside_radius(pos, 0.9)
		for _, obj in pairs(objs) do 
			if obj:get_player_name() == "singleplayer" then
				local img = "title.png^[colorize:#ffffff:50"
				img = citadel.shadow(img, 256, 144, 1)
				citadel.hud("title", img, 4)
				minetest.set_node(pos, {name = "air"})
				return false
			end
		end
		return true
	end,
})

for i = 1,12 do
	minetest.register_node(cc.."stone_with_glyph_"..i, {
		description = "stone with glyph "..i,
		tiles = {"stone.png^glyph"..i..".png"},
		groups = {cracky=2},
		sounds = citadel.nodecore_sounds("stony"),
	})
end

--colectables
function register_collectable(name, desc)
	minetest.register_craftitem(cc..name, {
		description = desc,
		inventory_image = name..".png",
		stack_max = 1,
	})
	minetest.register_node(cc..name.."_node", {
		description = desc.." node",
		tiles = {name..".png"},
		groups = {cracky=2, breakable = 1, sparkle = 1, unique = 1},
		drawtype = "signlike",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		selection_box = {
			type = "wallmounted",
		},
		drop = cc..name,
		_on_unique = citadel.unique_item(cc..name)
	})
end
register_collectable("pendant", "Ancient Pendant")
register_collectable("tablet", "Ancient Tablet")
register_collectable("amulet", "Ancient Amulet")
register_collectable("sigil", "Ancient Sigil")
register_collectable("scepter", "Ancient Scepter")
register_collectable("coin", "Ancient Coin")
register_collectable("totem", "Oddly Shaped Totem")

minetest.register_abm({
	label = "Uniqueness Check",
	nodenames = {"group:unique"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		node = node or minetest.get_node(pos)
		local def = minetest.registered_nodes[node.name]
		if def and def._on_unique then
			def._on_unique(pos, node)
		end
	end
})

--sparkle abm
minetest.register_abm({
    label = "Sparkles",
    nodenames = {"group:sparkle"},
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
			minpos = {x=pos.x-0.5, y=pos.y-0.5, z=pos.z-0.5},
			maxpos = {x=pos.x+0.5, y=pos.y+0.5, z=pos.z+0.5},
			minvel = {x=0, y=0.1, z=0},
			maxvel = {x=0, y=1, z=0},
		})
	end,
})
--trigger lbm
minetest.register_lbm({
    label = "trigger",
    name = cc.."triggerlbm",
    nodenames = {cc.."trigger"},
    run_at_every_load = true,
    action = function(pos, node, dtime_s)
		minetest.get_node_timer(pos):start(0.1)
    end
})
--delete things
minetest.register_abm({
    label = "delete",
    interval = 0.5,
    chance = 1,
    min_y = -200,
    max_y = 200,
    nodenames = {cc.."pendant",cc.."coin",cc.."backward_stone_node",cc.."foward_stone_node",cc.."break_stone_node",cc.."unlock_stone_node",cc.."totem",cc.."scepter",cc.."sigil",cc.."amulet",cc.."tablet"},
    action = function(pos, node, dtime_s)
		local player = minetest.get_player_by_name("singleplayer")
		if player:get_inventory():contains_item("main", minetest.registered_items[minetest.get_node(pos).name].drop) then
			minetest.set_node(pos,{name="air"})
		end
    end
})

minetest.register_alias(cc.."star", "air")