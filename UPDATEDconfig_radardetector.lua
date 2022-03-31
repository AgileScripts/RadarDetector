local Config = {}

Config.ScriptEnabled = true
Config.ScriptName = "RadarDetector"
Config.ScriptAuthor = "Brentopc"
Config.ScriptVersion = "v0.9.1"
Config.ConfigVersion = "v0.9.1"

Config.KaBandRange = 200

Config.KBandRange = 400
Config.KBandFakeLocations = {
	vector3(1838.65, 3673.96, 35.28),
	vector3(299.2, -584.7, 43.26),
	vector3(357.38, -590.57, 28.79),
	vector3(401.08, -1609.42, 29.38),
	vector3(416.61, -1653.78, 29.29),
	vector3(-1038.6, -1382.14, 5.55),
}

if Config.ScriptEnabled then
    AddConfig(Config.ScriptName, Config)
end
