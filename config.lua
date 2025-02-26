--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application =
{
	content =
	{
		width = 1024,
		height = 1724, 
		scale = "letterbox",
		fps = 60,
		default = "landscape", supported = { "landscape" },
		--[[
		scale = "letterbox",
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}