local level = 4

minetest.register_on_mods_loaded(function ()
	for i, def in pairs(minetest.registered_nodes) do
		local light_source = def.light_source
		if light_source == nil or light_source < level then
			minetest.override_item(i, { light_source = level })
		end
	end
end)
