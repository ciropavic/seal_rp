DROP TABLE IF EXISTS `biznisi`;
CREATE TABLE IF NOT EXISTS `biznisi` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ime` text NOT NULL,
  `Label` text NOT NULL,
  `Koord` longtext NOT NULL DEFAULT '{}',
  `Sef` int(20) NOT NULL DEFAULT 0,
  `Vlasnik` varchar(60) DEFAULT NULL,
  `Posao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

INSERT INTO `biznisi` (`ID`, `Ime`, `Label`, `Koord`, `Sef`, `Vlasnik`, `Posao`) VALUES
(4, 'drvosjeca', 'Drvosjeca', '[1189.6624755859376,-1278.3201904296876,34.89719009399414]', 0, NULL, 'drvosjeca'),
(3, 'kosac', 'Kosac trave', '[-1366.4168701171876,56.53075408935547,53.09845733642578]', 0, NULL, 'kosac'),
(5, 'farmer', 'Farmer', '[2415.745849609375,4993.283203125,45.2213249206543]', 0, NULL, 'farmer'),
(6, 'kamion', 'Kamiondzija', '[1183.4019775390626,-3303.89501953125,5.9168572425842289]', 0, NULL, 'kamion'),
(7, 'elektricar', 'Elektricar', '[-617.70166015625,-1623.2904052734376,32.010536193847659]', 0, NULL, 'elektricar'),
(8, 'dostavljac', 'Dostavljac', '[812.78662109375,-911.2910766601563,24.41560173034668]', 0, NULL, 'deliverer'),
(9, 'vodoinstalater', 'Vodoinstalater', '[990.3715209960938,-1853.208984375,30.039819717407228]', 0, NULL, 'vodoinstalater'),
(10, 'vatrogasac', 'Vatrogasci', '[210.68028259277345,-1656.9088134765626,28.80321502685547]', 0, NULL, 'vatrogasac'),
(11, 'garbage', 'Smetlari', '[-355.04974365234377,-1513.8880615234376,26.71724510192871]', 0, NULL, 'garbage');
COMMIT;
