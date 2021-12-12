--
-- Table structure for table `mafije`
--

DROP TABLE IF EXISTS `mafije`;
CREATE TABLE IF NOT EXISTS `mafije` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ime` varchar(60) NOT NULL,
  `Label` varchar(60) NOT NULL,
  `Rankovi` varchar(255) NOT NULL DEFAULT '{}',
  `Oruzarnica` varchar(250) NOT NULL DEFAULT '{}',
  `Lider` varchar(250) NOT NULL DEFAULT '{}',
  `SpawnV` varchar(250) NOT NULL DEFAULT '{}',
  `DeleteV` varchar(250) NOT NULL DEFAULT '{}',
  `LokVozila` varchar(250) NOT NULL DEFAULT '{}',
  `CrateDrop` varchar(250) NOT NULL DEFAULT '{}',
  `Vozila` varchar(255) NOT NULL DEFAULT '{}',
  `Oruzja` varchar(255) NOT NULL DEFAULT '{}',
  `Boje` varchar(255) NOT NULL DEFAULT '{}',
  `Ulaz` varchar(250) NOT NULL DEFAULT '{}',
  `Izlaz` varchar(250) NOT NULL DEFAULT '{}',
  `Gradonacelnik` int(11) NOT NULL DEFAULT 0,
  `DeleteV2` varchar(255) NOT NULL DEFAULT '{}',
  `LokVozila2` varchar(250) NOT NULL DEFAULT '{}',
  `Kokain` varchar(255) NOT NULL DEFAULT '{}',
  `KamionK` varchar(255) NOT NULL DEFAULT '{}',
  `Skladiste` int(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;
