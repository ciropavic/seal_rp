USE `essentialmode`;

CREATE TABLE `weashops2` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `owner` varchar(60) NULL,
  `sef` int(11) NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO `weashops2` (name, owner, sef) VALUES
	('GunShop1',null,0),
	('GunShop2',null,0),
	('GunShop3',null,0),
	('GunShop4',null,0),
	('GunShop5',null,0),
	('GunShop6',null,0),
	('GunShop7',null,0),
	('GunShop8',null,0),
	('GunShop9',null,0),
	('GunShop10',null,0)
;

INSERT INTO `weashops` (name, item, price) VALUES
	('GunShop','WEAPON_CARBINERIFLE',20000)
;
