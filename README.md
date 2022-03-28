# RadarDetector by Brentopc

## Resource Description
RadarDetector is a resource that adds a radar dector to vehicles.  It works by using the wk_wars2x radar script to detect Officers running radar.  The script has configurable K Band and Ka Band.  Ka Band is short range but 100% accurate while K Band is long range but has false alarms that are configurable.

## Instructions on how to Install
Alter the `owned_vehicles` table to store vehicle accessories by running this Query

```ALTER TABLE `owned_vehicles` ADD `accessories` LONGTEXT NULL DEFAULT NULL```
