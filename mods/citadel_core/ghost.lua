local dia_timing = {
	[1] = 6.170,
	[2] = 4.216,
	[3] = 6.109,
	[4] = 4.302,
	[5] = 5.726,
	[6] = 3.227,
	[7] = 3.562,
	[8] = 3.227,
	[9] = 5.287,
	[10] = 4.874,
	[11] = 7.473,
	[12] = 4.519,
	[13] = 6.734,
	[14] = 4.342,
	[15] = 3.278,
	[16] = 4.402,
	[17] = 2.539,
	[18] = 3.520,
	[19] = 4.231,
	[20] = 5.558,
	[21] = 9.266,
	[22] = 6.112,
	[23] = 5.061,
	[24] = 9.914,
	[50] = 7.534,
}
for k, v in pairs(dia_timing) do
	dia_timing[k] = v - 1.5 -- ignore trailing reverb
end

local ghost_sound_ids = {}

minetest.register_entity(cc.."ghost", {
	initial_properties = {
		visual = "mesh",
		mesh = "character.b3d",
		visual_size = { x=1, y=1, z=1 },
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		textures = {"ghost.png"},
		physical = false,
		glow = 10,
		use_texture_alpha = true,
		backface_culling = false,
		damage_texture_modifier = "",
		hp_max = 100000,
	},
	_anim_timer = 0,
	_images= {},
	_image_index = 1,
	_factor = 1,
	_by_player = false,
	on_rightclick = function(self, clicker)
		if (not self._image_index) or (self._image_index > #self._images) then
			self._image_index = 1
		end
 
		local diaid = self._images[self._image_index]

		-- Smoothly stop old ghost sounds
		for k in pairs(ghost_sound_ids) do
			minetest.sound_fade(k, 2, 0)
		end
		ghost_sound_ids = {}

		self._audio_duck_time = dia_timing[diaid]
 
		-- Play ghost sounds with a spread out spatial effect
		-- (start_time in MT 5.8+) for a more other-worldy effect
		local qty = 3
		local offs = math.random() * math.pi * 2
		for i = 1, qty do
			ghost_sound_ids[minetest.sound_play("dia"..diaid, {
				pos = vector.offset(self.object:get_pos(),
					math.sin(i * 2 / qty * math.pi + offs) * 2,
					1.8,
					math.cos(i * 2 / qty * math.pi + offs) * 2),
				gain = 2,
				start_time = i / qty * 0.05
			})] = true
		end

		local img = "text_overlay.png^dia"..diaid..".png^[colorize:#ffffff:200"
		img = citadel.shadow(img, 592, 336)
		citadel.hud("ghost", img, dia_timing[diaid])

		--endgame stuff
		if diaid == 50 then
			minetest.after(5, function(self) 
				self._factor = 0
				self.object:set_velocity({x=0,y=10,z=0})
			end, self)
			minetest.after(6, function() minetest.clear_objects() end)
			minetest.after(8, function() citadel.hud("white", "white_hud.png") end)
			minetest.after(9, function()
				local player = minetest.get_player_by_name("singleplayer")
				player:set_pos(minetest.deserialize(data:get_string("endpos")))
			end)
		end
		
		self._image_index = self._image_index + 1
	end,
	get_staticdata = function(self)
		return minetest.serialize(self._images)
	end,
	on_activate = function(self, staticdata, dtime_s)
	    self.object:set_texture_mod("^[opacity:100")
		self.object:set_velocity({x=0,y=0.1,z=0})
		self._images = minetest.deserialize(staticdata)
		self.object:set_armor_groups({immortal = 1})
	end,
	on_step = function(self, dtime_s)
		if self._audio_duck_time then
			self._audio_duck_time = self._audio_duck_time - dtime_s
			if self._audio_duck_time <= 0 then
				self._audio_duck_time = nil
			end
		end
		
		self._anim_timer = self._anim_timer + dtime_s*self._factor
		if self._anim_timer > 2 then
			self.object:set_velocity({x=0,y=0-self.object:get_velocity().y,z=0})
			self._anim_timer = 0
		end

		local objects = minetest.get_objects_inside_radius(self.object:get_pos(), 5)
		for o=1, #objects do
			local obj = objects[o]
			if obj and obj:is_player() then
				local dir = vector.direction(self.object:get_pos(),obj:get_pos())
				local yaw = minetest.dir_to_yaw(dir)
				if yaw then
					self.object:set_yaw(yaw)
					break
				end
			end
		end
	end,
})

