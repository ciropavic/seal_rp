--
-- Table structure for table `mafije`
--

DROP TABLE IF EXISTS `mafije`;
CREATE TABLE IF NOT EXISTS `mafije` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ime` varchar(60) NOT NULL,
  `Label` varchar(60) NOT NULL,
  `Rankovi` varchar(255) NOT NULL DEFAULT '{}',
  `Oruzarnica` varchar(50) NOT NULL DEFAULT '{}',
  `Lider` varchar(50) NOT NULL DEFAULT '{}',
  `SpawnV` varchar(50) NOT NULL DEFAULT '{}',
  `DeleteV` varchar(50) NOT NULL DEFAULT '{}',
  `LokVozila` varchar(150) NOT NULL DEFAULT '{}',
  `CrateDrop` varchar(50) NOT NULL DEFAULT '{}',
  `Vozila` varchar(255) NOT NULL DEFAULT '{}',
  `Oruzja` varchar(255) NOT NULL DEFAULT '{}',
  `Boje` varchar(255) NOT NULL DEFAULT '{}',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;
