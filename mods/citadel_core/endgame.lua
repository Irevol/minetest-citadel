
minetest.register_entity(cc.."crystal", {
	initial_properties = {
		visual = "mesh",
		mesh = "crystal2.obj",
		visual_size = { x=5, y=5, z=5 },
		collisionbox = {-0.5, -1, -0.5, 0.5, 1, 0.5},
		selectionbox = {-0.5, -1, -0.5, 0.5, 1, 0.5},
		textures = {"crystal.png"},
		physical = false,
		glow = 10,
		use_texture_alpha = true,
		backface_culling = false,
		damage_texture_modifier = "",
		hp_max = 100000,
		automatic_rotate = 2,
	},
	_anim_timer = 0,
	on_rightclick = function(self, clicker)
		
	end,
	on_activate = function(self, staticdata, dtime_s)
	    self.object:set_texture_mod("^[opacity:128")
		self.object:set_velocity({x=0,y=0.3,z=0})
		--object:set_armor_groups({immortal = 1})
	end,
	on_step = function(self, dtime_s)
		
		self._anim_timer = self._anim_timer + dtime_s
		if self._anim_timer > 2 then
			self.object:set_velocity({x=0,y=0-self.object:get_velocity().y,z=0})
			self._anim_timer = 0
		end
		
	end,
})

