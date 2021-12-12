USE `essentialmode`;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('chemicals', 'Kemikalije', 20, 0, 1),
	('chemicalslisence', 'Chemicals license', 1, 0, 1),
	('moneywash', 'MoneyWash License', 1, 0, 1),
	('poppyresin', 'Makova smola', 20, 0, 1),
	('lsa', 'LSA', 20, 0, 1),
	('hydrochloric_acid', 'Hidrokloricna kiselina', 15, 0, 1),
	('sodium_hydroxide', 'Natrijev hidroksid', 15, 0, 1),
	('sulfuric_acid', 'Sumporna kiselina', 15, 0, 1),
	('thionyl_chloride', 'Thionil klorid', 20, 0, 1)
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weed_processing', 'Weed Processing License')
	('chemicalslisence', 'Chemicals license')
;
