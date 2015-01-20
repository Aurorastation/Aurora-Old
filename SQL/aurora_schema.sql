-- ------------------------------
-- Custom Items Table
-- tgstation.aurora_customitems
-- ------------------------------
CREATE TABLE `aurora_customitems` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`ckey` VARCHAR(32) NOT NULL,
    `character` VARCHAR(32) NOT NULL,
    `item` VARCHAR(124) NOT NULL,
    `job` TEXT NULL,	-- Job restrictions go here. Can be left blank. Format is Job One,Job Two,Job Three Point Five
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Blacklisted IP table
-- tgstation.aurora_ipblacklist
-- ------------------------------
CREATE TABLE `aurora_ipblacklist` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,	-- Auto-incremented, had issues with a missing ID field, so here
    `ip` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Forms table
-- tgstation.aurora_forms
-- ------------------------------
CREATE TABLE `aurora_forms` (
	`id` VARCHAR(4) NOT NULL,
    `name` VARCHAR(32) NOT NULL,	-- Name for the paper
    `department` VARCHAR(32) NOT NULL, -- What department, one word, usually
    `data` TEXT NOT NULL, -- The contents of the paper itself, formatted in BB
    `info` TEXT NULL, -- Info for further request, plain text
    PRIMARY KEY(`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;