-- sfinv/init.lua

dofile(minetest.get_modpath("sfinv") .. "/api.lua")

-- Load support for MT game translation.
local S = minetest.get_translator("sfinv")

sfinv.register_page("sfinv:crafting", {
	title = "Tips",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				label[0.1,0.5;Use both decay and growth to traverse the ruins!]
				label[0.1,1;Are the tales of a tortured spirit who lives here more than superstition?]
				label[0.1,1.5;Can you find all 7 Ancient Artifacts?]
				label[0.1,2;Can you find a mysterious floating crystal, said to hold the secrets of immortality?]
				label[0.1,2.5;Time traveling into a wall is unlikely to work.]
				label[0.1,3;Plants that have rubble fall on them are likely to die]
				label[0.1,3.5;If you're stuck, contact Irevol via ContentDB or the fourms (: This game is kinda hard]
			]], true)
	end
})
