CREATE TABLE `ds_garages` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `garage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `ds_garages`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ds_garages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

ALTER TABLE `owned_vehicles` ADD `garage` INT NULL; 