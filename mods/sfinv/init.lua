-- sfinv/init.lua

dofile(minetest.get_modpath("sfinv") .. "/api.lua")

sfinv.register_page("sfinv:inventory", {
	title = "Inventory",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				
			]], true)
	end
})
sfinv.register_page("sfinv:tips", {
	title = "Tips",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				textarea[0.1,0.1;9.8,8.9;;
					Use both decay and growth to traverse the ruins!
					Are the tales of a tortured spirit who lives here more than superstition?
					Can you find all 7 Ancient Artifacts?
					Can you find a mysterious floating crystal, said to hold the secrets of immortality?
					Time traveling into a wall is unlikely to work.
					lants that have rubble fall on them are likely to die
					If you're stuck, contact Irevol via ContentDB or the fourms (:
				;]
			]], false, "size[10,9.1]")
	end
})
