ALTER TABLE `owned_vehicles` ADD `state` int(1) NOT NULL DEFAULT 1 COMMENT 'State vozila' AFTER `owner`;
ALTER TABLE `owned_vehicles` ADD `mjenjac` int(11) NOT NULL DEFAULT 1;
ALTER TABLE `owned_vehicles` ADD `brod` int(11) NOT NULL DEFAULT 0;