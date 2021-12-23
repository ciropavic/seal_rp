ALTER TABLE owned_vehicles
	ADD COLUMN mjenjac int NOT NULL DEFAULT(1)
;

ALTER TABLE vehicles_for_sale
	ADD COLUMN mjenjac int NOT NULL DEFAULT(1)
;