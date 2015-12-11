-- ------------------------------
-- Custom Items Table
-- tgstation.ss13_customitems
-- ------------------------------
CREATE TABLE `ss13_customitems` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`ckey` VARCHAR(32) NOT NULL,
    `real_name` VARCHAR(32) NOT NULL,
    `item` VARCHAR(124) NOT NULL,
    `job` TEXT NULL,	-- Job restrictions go here. Can be left blank. Format is Job One,Job Two,Job Three Point Five
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Blacklisted IP table
-- tgstation.ss13_ipblacklist
-- ------------------------------
CREATE TABLE `ss13_ipblacklist` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,	-- Auto-incremented, had issues with a missing ID field, so here
    `ip` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Forms table
-- tgstation.ss13_forms
-- ------------------------------
CREATE TABLE `ss13_forms` (
	`id` VARCHAR(4) NOT NULL,
    `name` VARCHAR(32) NOT NULL,	-- Name for the paper
    `department` VARCHAR(32) NOT NULL, -- What department, one word, usually
    `data` TEXT NOT NULL, -- The contents of the paper itself, formatted in BB
    `info` TEXT NULL, -- Info for further request, plain text
    PRIMARY KEY(`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Warnings table
-- tgstation.ss13_warnings
-- ------------------------------
CREATE TABLE `ss13_warnings` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`time` DATETIME NOT NULL,
    `severity` TINYINT(1) NOT NULL,
    `reason` TEXT NOT NULL,
    `notes` TEXT NULL,
    `ckey` VARCHAR(32) NOT NULL,
    `computerid` VARCHAR(32) NOT NULL,
    `ip` VARCHAR(32) NOT NULL,
    `a_ckey` VARCHAR(32) NOT NULL,
    `acknowledged` TINYINT(1) NULL DEFAULT '0',
    `expired` TINYINT(1) NULL DEFAULT '0',
    `visible` TINYINT(1) NULL DEFAULT '1',
    `edited` TINYINT(1) NULL DEFAULT '0',
    `lasteditor` VARCHAR(32) NULL DEFAULT NULL,
    `lasteditdate` DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- Station Directives table
-- tgstation.ss13_directives
-- ------------------------------
CREATE TABLE `ss13_directives` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(64) NOT NULL,
    `data` TEXT NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- SQL based Newsfeed table
-- tgstation.ss13_news
-- ------------------------------
CREATE TABLE `ss13_news` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
    `publishtime` INT(11) NOT NULL,
    `channel` VARCHAR(64) NOT NULL,
    `author` VARCHAR(64) NOT NULL,
	`title` VARCHAR(64) NOT NULL,
    `body` TEXT NOT NULL,
	`status` TINYINT(1) NOT NULL DEFAULT 1,
	`uploadip` VARCHAR(18) NOT NULL,
	`uploadtime` DATETIME NOT NULL,
	`approvetime` DATETIME DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- SQL based player notes table
-- tgstation.ss13_notes
-- ------------------------------
CREATE TABLE `ss13_notes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `adddate` DATETIME NOT NULL,
  `ckey` VARCHAR(32) NOT NULL,
  `ip` VARCHAR(18) NULL DEFAULT NULL,
  `computerid` VARCHAR(32) NULL DEFAULT NULL,
  `a_ckey` VARCHAR(32) NOT NULL,
  `content` TEXT(65535) NOT NULL,
  `visible` TINYINT(1) NOT NULL DEFAULT 1,
  `edited` TINYINT(1) NOT NULL DEFAULT 0,
  `lasteditor` VARCHAR(32) NULL DEFAULT NULL,
  `lasteditdate` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1;

-- ------------------------------
-- SQL based secret santi klaus table
-- tgstation.ss13_santa
-- ------------------------------
CREATE TABLE `ss13_santa` (
  `character_name` varchar(32) NOT NULL,
  `participation_status` tinyint(1) NOT NULL DEFAULT '1',
  `mark_name` varchar(32) DEFAULT NULL,
  `character_gender` varchar(32) NOT NULL,
  `character_species` varchar(32) NOT NULL,
  `character_job` varchar(32) NOT NULL,
  `character_like` mediumtext NOT NULL,
  `gift_assigned` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`character_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
