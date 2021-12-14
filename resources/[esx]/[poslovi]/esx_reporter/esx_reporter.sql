INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_reporter','Reporter',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_reporter','Reporter',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_reporter', 'Reporter', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('reporter', 'Reporter', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('reporter', 0, 'soldato', 'Pocetnik', 1500, '{}', '{}'),
('reporter', 1, 'capo', 'Novinar', 1800, '{}', '{}'),
('reporter', 2, 'consigliere', 'Reporter', 2100, '{}', '{}'),
('reporter', 3, 'boss', 'Sef', 2700, '{}', '{}');