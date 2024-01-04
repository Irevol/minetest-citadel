
minetest.register_craftitem(cc.."letter", {
	description = "Letter",
	inventory_image = "letter_inv.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		minetest.show_formspec("singleplayer", cc.."letter_form",
			"size[26,19]"..
			"image_button_exit[0.5,0.5;12,18;letter1.png;letter1;]"..
			"image_button_exit[13,0.5;12,18;letter2.png;letter2;]"
		)
	end,
})

