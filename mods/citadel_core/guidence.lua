
minetest.register_craftitem(cc.."letter", {
	description = "Letter",
	inventory_image = "letter_inv.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		minetest.show_formspec("singleplayer", cc.."letter_form",
			"size[26,19]"..
			"image_button_exit[0.5,0.5;12,18;(letter_background.png^[resize:1024x1536)^letter_1.png;letter1;]"..
			"image_button_exit[13,0.5;12,18;(letter_background.png^[resize:1024x1536)^letter_2.png;letter1;]"
		)
	end,
})

local function get_page(page)
	local page_table = {cc.."amulet",cc.."pendant",cc.."coin",cc.."sigil",cc.."scepter",cc.."tablet",cc.."totem"}
	local text = "book_unknown.png"
	local modifier = "^[colorize:#000000:255"
	local player = minetest.get_player_by_name("singleplayer")
	if player:get_inventory():contains_item("main", page_table[page]) then
		text = "book_"..page..".png"
		modifier = ""
	end
	return 
		"formspec_version[6]"..
		"size[27,14]"..
		"bgcolor[#ffffff;neither;]"..
		"image[3,0;21,14;(book_background.png^[resize:1536x1024)^"..text.."]"..
		"image[4.5,2.5;6,6;("..minetest.registered_items[page_table[page]].inventory_image.."^[resize:256x256)"..modifier.."]"..
		"image_button[0,5;2,2;book_arrow.png;back;]"..
		"image_button[25,5;2,2;book_arrow_rotated.png;foward;]"
		
end
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local meta = minetest.get_player_by_name("singleplayer"):get_meta()
	local page = meta:get_int("page") or 1
	if fields.back then 
		page = page-1
		if page == 0 then
			page = 7
		end
		meta:set_int("page",page)
		minetest.show_formspec("singleplayer", cc.."book_form", get_page(page))
	end
	if fields.foward then 
		page = page+1
		if page == 8 then
			page = 1
		end
		meta:set_int("page",page)
		minetest.show_formspec("singleplayer", cc.."book_form", get_page(page))
	end
end)
minetest.register_craftitem(cc.."book", {
	description = "Journal",
	inventory_image = "book_inv.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local page = minetest.get_player_by_name("singleplayer"):get_meta():get_int("page")
		minetest.show_formspec("singleplayer", cc.."book_form", get_page(page))
	end,
})

