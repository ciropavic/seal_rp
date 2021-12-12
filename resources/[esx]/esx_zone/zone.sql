DROP TABLE IF EXISTS `zone`;
CREATE TABLE IF NOT EXISTS `zone` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ime` varchar(250) NOT NULL,
  `koord` varchar(255) NOT NULL,
  `velicina` int(11) NOT NULL,
  `rotacija` int(11) NOT NULL,
  `boja` int(11) NOT NULL DEFAULT 0,
  `vlasnik` varchar(35) DEFAULT NULL,
  `label` varchar(250) DEFAULT NULL,
  `vrijeme` int(11) NOT NULL DEFAULT 0,
  `vrijednost` int(11) NOT NULL DEFAULT 30000,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `zpostavke`;
CREATE TABLE IF NOT EXISTS `zpostavke` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idzone` int(11) NOT NULL,
  `mafije` longtext NOT NULL,
  `vrijeme` int(11) NOT NULL,
  `sat` int(11) NOT NULL DEFAULT 0,
  `minuta` int(11) NOT NULL DEFAULT 0,
  `zauzimanje` int(11) NOT NULL DEFAULT 10,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `zpostavke` (`id`, `idzone`, `mafije`, `vrijeme`, `sat`, `minuta`, `zauzimanje`) VALUES
(1, 1, '[]', 24, 0, 0, 10);

