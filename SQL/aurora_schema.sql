-- ------------------------------
-- Custom Items Table
-- tgstation.aurora_customitems
-- ------------------------------
CREATE TABLE `aurora_customitems` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`ckey` VARCHAR(32) NOT NULL,
    `real_name` VARCHAR(32) NOT NULL,
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

-- ------------------------------
-- Warnings table
-- tgstation.aurora_warnings
-- ------------------------------
CREATE TABLE `aurora_warnings` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`time` DATETIME NOT NULL,
    `severity` TINYINT(1) NOT NULL,
    `reason` TEXT NOT NULL,
    `notes` TEXT NULL,
    `ckey` VARCHAR(32) NOT NULL,
    `computerid` VARCHAR(32) NOT NULL,
    `ip` VARCHAR(32) NOT NULL,
    `a_ckey` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Station Directives table
-- tgstation.aurora_directives
-- ------------------------------
CREATE TABLE `aurora_directives` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(64) NOT NULL,
    `data` TEXT NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- SQL based Newsfeed table
-- tgstation.aurora_news
-- ------------------------------
CREATE TABLE `aurora_news` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
    `publishtime` INT(11) NOT NULL,
    `channel` VARCHAR(64) NOT NULL,
    `author` VARCHAR(64) NOT NULL,
    `body` TEXT NOT NULL,
    `notpublishing` TINYINT(1) DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;