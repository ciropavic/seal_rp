--
-- Table structure for table `zemljista`
--

DROP TABLE IF EXISTS `imanja`;
CREATE TABLE IF NOT EXISTS `imanja` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ime` varchar(255) NOT NULL,
  `Koord1` longtext NOT NULL DEFAULT '{}',
  `Koord2` longtext NOT NULL DEFAULT '{}',
  `Cijena` int(11) NOT NULL DEFAULT 0,
  `Vlasnik` int(11) DEFAULT NULL,
  `Kuca` varchar(255) DEFAULT NULL,
  `KKoord` longtext NOT NULL DEFAULT '{}',
  `MKoord` longtext NOT NULL DEFAULT '{}',
  `KucaID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;