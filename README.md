# RadarDetector by Brentopc

Requires Miggens Scripts Framework https://miggensscripts.tebex.io/

# Resource Description

RadarDetector is a resource that adds a radar dector to vehicles.  It works by using the wk_wars2x radar script to detect Officers running radar.  The script has configurable K Band and Ka Band.  Ka Band is short range but 100% accurate while K Band is long range but has false alarms that are configurable.

## How to Install

1. Drag the resource into the `[MiggensScripts]/MiggensScripts/Resources` folder.
2. Edit the `config` file and set `Config.ScriptEnabled` to true.
3. Rename and remove `UPDATED` from the `config` file
4. Ensure that the latest version of `wk_wars2x` is installed.
5. If using ESX, add the configured item to your `items` table, and set `UseESX` to true.
6. If using mysql-async alone or with ESX, alter the `owned_vehicles` table to store vehicle accessories by running this query.
```ALTER TABLE `owned_vehicles` ADD `accessories` LONGTEXT NULL DEFAULT NULL```
