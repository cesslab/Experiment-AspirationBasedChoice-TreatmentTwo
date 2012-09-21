DROP DATABASE IF EXISTS bundle_experiment;
CREATE DATABASE bundle_experiment;

USE bundle_experiment;


/**-----------------------------**/
/**     Codeigniter Tables      **/
/**-----------------------------**/
DROP TABLE IF EXISTS `ci_sessions`;
CREATE TABLE `ci_sessions` (
    session_id          VARCHAR(40) DEFAULT '0' NOT NULL,
    ip_address          VARCHAR(16) DEFAULT '0' NOT NULL,
    user_agent          VARCHAR(50) NOT NULL,
    last_activity       int(10) unsigned DEFAULT 0 NOT NULL,
    user_data           text NOT NULL,
    PRIMARY KEY (session_id)
) ENGINE=InnoDB;

/**-----------------------------**/
/**     Universal Tables        **/
/**-----------------------------**/

DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
    id INTEGER primary key,
    question text NOT NULL
) ENGINE=InnoDB;

INSERT INTO questions(id, question) VALUES(1, 'Which of the following bundles do you chose?');
INSERT INTO questions(id, question) VALUES(2, 'Notice that one of the bundles from the previous stage is no longer available. Which remaining bundle do you choose?');
INSERT INTO questions(id, question) VALUES(3, 'This decision task is composed of only 1 stage, i.e. both bundles are guaranteed to be available. Which of the folllowing bundles do you choose?');
INSERT INTO questions(id, question) VALUES(4, 'Notice that two of the bundles from the previous stage are no longer available. Which remaining bundles do you choose?');
INSERT INTO questions(id, question) VALUES(5,
'<p>Previously, when asked to choose between {bundle_chosen} and the bundles listed
below, you chose {bundle_chosen}.</p><p>Now, suppose that you are given your preferred bundle {bundle_chosen}.
Next to each of the bundles listed below, please enter the minimum compensation in dollars you are willing to accept
to switch from {bundle_chosen} to that bundle, and then click on the Submit button at the end of the page.</p>
<p>Recall that it is in your own best interest to state the minimum compensation you are willing to accept.</p>');

DROP TABLE IF EXISTS `experimenters`;
CREATE TABLE `experimenters`(
    id                  INTEGER auto_increment PRIMARY KEY,
    login               VARCHAR(255) NOT NULL,
    password           VARCHAR(255) NOT NULL
)ENGINE=InnoDB;
INSERT INTO `experimenters`(login, password)
    values('Begum', MD5('password'));
INSERT INTO `experimenters`(login, password)
    values('admin', MD5('password'));
INSERT INTO `experimenters`(login, password)
    values('admin', MD5('password'));

DROP TABLE IF EXISTS `experiments`;
CREATE TABLE `experiments`(
    id INTEGER auto_increment PRIMARY KEY,
    num_subjects INTEGER NOT NULL DEFAULT 0,
    start_phase_one BOOLEAN NOT NULL DEFAULT FALSE,
    start_phase_two BOOLEAN NOT NULL DEFAULT FALSE,
    treatment enum("Before", "After") NOT NULL,
    showupfee double not null default 0
)ENGINE=InnoDB;
INSERT INTO `experiments`(num_subjects, treatment, showupfee)
    VALUES(2, "After", 5.0);
INSERT INTO `experiments`(num_subjects, treatment, showupfee)
    VALUES(2, "Before", 5.0);


DROP TABLE IF EXISTS `subjects`;
 CREATE TABLE `subjects`(
    id INTEGER auto_increment PRIMARY KEY,
    login VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    experiment_id INTEGER NOT NULL DEFAULT 0,
    current_round INTEGER NOT NULL DEFAULT 0,
    round_counter INTEGER NOT NULL DEFAULT 1,
    treatment enum("Before", "After") NOT NULL DEFAULT 'After',
    current_phase enum('not_logged_in', 'intro_phase_one','phase_one','intro_phase_two', 'phase_two', 'payoff', 'completed') NOT NULL DEFAULT 'not_logged_in',
    first_stage_order VARCHAR(255) NOT NULL DEFAULT '',
    first_stage_last_round INTEGER NOT NULL DEFAULT 0,
    second_stage_order VARCHAR(255) NOT NULL DEFAULT '',
    second_stage_last_round INTEGER NOT NULL DEFAULT 0,
    payoff DOUBLE NOT NULL DEFAULT 0,
    INDEX(experiment_id),
    FOREIGN KEY(experiment_id) REFERENCES experiments (id)
        ON DELETE CASCADE
)ENGINE=InnoDB;
INSERT INTO `subjects`(login,password, experiment_id)
    VALUES('test',MD5('test0011'), 1);
INSERT INTO `subjects`(login,password, experiment_id)
    VALUES('tester',MD5('tester0011'), 1);
INSERT INTO `subjects`(login,password, experiment_id, treatment)
    VALUES('test1',MD5('test0011'), 2, "Before");
INSERT INTO `subjects`(login,password, experiment_id, treatment)
    VALUES('test2',MD5('test0011'), 2, "Before");

DROP TABLE IF EXISTS `outcome`;
CREATE TABLE `outcome`(
    id INTEGER auto_increment PRIMARY KEY,
    experiment_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    phase_selected enum('phase_one','phase_two') NOT NULL,
    round_id INTEGER NOT NULL DEFAULT 0,
    bundle_id INTEGER NOT NULL,
    random_val DOUBLE NOT NULL,
    min_comp DOUBLE NOT NULL,
    bundle_desc VARCHAR(255) NOT NULL DEFAULT '',
    payoff varchar(255) NOT NULL DEFAULT ''
)ENGINE=InnoDB;

DROP TABLES IF EXISTS `minimum_compensation`;
CREATE TABLE `minimum_compensation`(
    id INTEGER auto_increment PRIMARY KEY,
    subject_id  INTEGER NOT NULL,
    round_id    INTEGER NOT NULL,
    bundle_id   INTEGER NOT NULL,
    amount     DOUBLE NOT NULL
) ENGINE=InnoDB;

DROP TABLES IF EXISTS `displayed_round_order`;
CREATE TABLE `displayed_round_order`(
	id INTEGER  auto_increment PRIMARY KEY,
	phase INTEGER NOT NULL,
	subject_id INTEGER NOT NULL,
	round_id	INTEGER NOT NULL,
	displayed_round	INTEGER NOT NULL
)ENGINE=InnoDB;


/**------------------------------**/
/**         After Treatment      **/
/**------------------------------**/

DROP TABLE IF EXISTS `after_one_rounds`;
 CREATE TABLE `after_one_rounds`(
    id INTEGER auto_increment primary key,
    stage_number INTEGER NOT NULL,
    round_type enum('parent','child', 'single') NOT NULL,
    parent_id INTEGER NOT NULL DEFAULT 0,
    question_id INTEGER NOT NULL,
    conditional_bundles boolean NOT NULL DEFAULT false,
    index(parent_id),
    index(stage_number),
    index(question_id)
) ENGINE=InnoDB;


DROP TABLES IF EXISTS `after_two_rounds`;
CREATE TABLE `after_two_rounds`(
    id INTEGER auto_increment primary key,
    round_id INTEGER NOT NULL
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `after_one_conditional`;
CREATE TABLE `after_one_conditional`(
    id INTEGER auto_increment PRIMARY KEY,
    subject_id INTEGER NOT NULL,
    round_id INTEGER NOT NULL,
    bundle_id INTEGER NOT NULL
)ENGINE=InnoDB;


DROP TABLE IF EXISTS `after_one_bundles`;
 CREATE TABLE `after_one_bundles`(
    id INTEGER auto_increment PRIMARY KEY,
    round_id INTEGER NOT NULL,
    availability boolean NOT NULL DEFAULT TRUE,
    INDEX (round_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `after_one_items`;
 CREATE TABLE `after_one_items`(
    id INTEGER auto_increment PRIMARY KEY,
    item_type VARCHAR(255) NOT NULL,
    item_number INTEGER NOT NULL,
    bundle_id INTEGER NOT NULL,
    INDEX(bundle_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `after_selected_bundles`;
CREATE TABLE `after_selected_bundles` (
    id INTEGER auto_increment PRIMARY KEY,
    round_id integer not null,
    subject_id integer not null,
    bundle_id integer not null
) ENGINE=InnoDB;



/**------------------------------**/
/**         Before Treatment     **/
/**------------------------------**/

DROP TABLE IF EXISTS `before_one_rounds`;
 CREATE TABLE `before_one_rounds`(
    id INTEGER auto_increment primary key,
    stage_number INTEGER NOT NULL default 1,
    round_type enum('parent','child', 'single') NOT NULL,
    parent_id INTEGER NOT NULL DEFAULT 0,
    question_id INTEGER NOT NULL,
    conditional_bundles boolean NOT NULL DEFAULT false,
    index(parent_id),
    index(stage_number),
    index(question_id)
) ENGINE=InnoDB;


DROP TABLES IF EXISTS `before_two_rounds`;
CREATE TABLE `before_two_rounds`(
    id INTEGER auto_increment primary key,
    round_id INTEGER NOT NULL
) ENGINE=InnoDB;



DROP TABLES IF EXISTS `before_minimum_compensation`;
CREATE TABLE `before_minimum_compensation`(
    id INTEGER auto_increment PRIMARY KEY,
    subject_id  INTEGER NOT NULL,
    round_id    INTEGER NOT NULL,
    bundle_id   INTEGER NOT NULL,
    amount     DOUBLE NOT NULL
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `before_one_conditional`;
CREATE TABLE `before_one_conditional`(
    id INTEGER auto_increment PRIMARY KEY,
    subject_id INTEGER NOT NULL,
    round_id INTEGER NOT NULL,
    bundle_id INTEGER NOT NULL
)ENGINE=InnoDB;


DROP TABLE IF EXISTS `before_one_bundles`;
 CREATE TABLE `before_one_bundles`(
    id INTEGER auto_increment PRIMARY KEY,
    round_id INTEGER NOT NULL,
    availability boolean NOT NULL DEFAULT TRUE,
    INDEX (round_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `before_one_items`;
 CREATE TABLE `before_one_items`(
    id INTEGER auto_increment PRIMARY KEY,
    item_type VARCHAR(255) NOT NULL,
    item_number INTEGER NOT NULL,
    bundle_id INTEGER NOT NULL,
    INDEX(bundle_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `before_selected_bundles`;
CREATE TABLE `before_selected_bundles` (
    id INTEGER auto_increment PRIMARY KEY,
    round_id integer not null,
    subject_id integer not null,
    bundle_id integer not null
) ENGINE=InnoDB;


/**------------------------------**/
/**         Treatment Data       **/
/**------------------------------**/

select "Add Rounds";
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(1, 1, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(2, 1, 'child', 2, 1, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(3, 2, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(4, 2, 'child', 2, 3, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(5, 3, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(6, 4, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(7, 4, 'child', 2, 6, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(8, 5, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(9, 5, 'child', 2, 8, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(10, 6, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(11, 7, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(12, 7, 'child', 2, 11, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(13, 8, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(14, 8, 'child', 2, 13, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(15, 9, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(16, 9, 'child', 2, 15, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(17, 10, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(18, 10, 'child', 2, 17, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(19, 11, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(20, 11, 'child', 4, 19, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(21, 12, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(22, 12, 'child', 2, 21, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(23, 13, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(24, 13, 'child', 4, 23, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(25, 14, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(26, 14, 'child', 2, 25, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(27, 15, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(28, 16, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(29, 17, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(30, 18, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(31, 19, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(32, 20, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(33, 20, 'child', 2, 32, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(34, 21, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(35, 22, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(36, 22, 'child', 2, 35, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(37, 23, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(38, 23, 'child', 2, 37, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(39, 24, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(40, 24, 'child', 2, 39, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(41, 25, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(42, 26, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(43, 26, 'child', 2, 42, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(44, 27, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(45, 27, 'child', 2, 44, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(46, 28, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(47, 28, 'child', 2, 46, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(48, 29, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(49, 30, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(50, 30, 'child', 2, 49, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(51, 31, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(52, 31, 'child', 2, 51, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(53, 32, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(54, 32, 'child', 2, 53, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(55, 33, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(56, 33, 'child', 2, 55, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(57, 34, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(58, 34, 'child', 2, 57, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(59, 35, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(60, 35, 'child', 4, 59, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(61, 36, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(62, 36, 'child', 4, 61, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(63, 37, 'parent', 1, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(64, 37, 'child', 4, 63, TRUE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(65, 38, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(66, 39, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(67, 40, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(68, 41, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(69, 42, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(70, 43, 'single', 3, 0, FALSE);
INSERT INTO after_one_rounds(id, stage_number, round_type, question_id, parent_id, conditional_bundles) VALUES(71, 44, 'single', 3, 0, FALSE);

INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(1, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(2, 1, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(3, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(4, 3, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(5, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(6, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(7, 6, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(8, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(9, 8, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(10, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(11, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(12, 11, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(13, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(14, 13, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(15, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(16, 15, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(17, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(18, 17, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(19, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(20, 19, 'child', 4, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(21, 19, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(22, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(23, 22, 'child', 4, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(24, 22, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(25, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(26, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(27, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(28, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(29, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(30, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(31, 30, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(32, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(33, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(34, 33, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(35, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(36, 35, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(37, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(38, 37, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(39, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(40, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(41, 40, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(42, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(43, 42, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(44, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(45, 44, 'child', 2, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(46, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(47, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(48, 47, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(49, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(50, 49, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(51, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(52, 51, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(53, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(54, 53, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(55, 0, 'parent', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(56, 55, 'child', 2, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(57, 47, 'child', 4, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(58, 47, 'child', 4, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(59, 47, 'child', 4, TRUE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(60, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(61, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(62, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(63, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(64, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(65, 0, 'single', 1, FALSE);
INSERT INTO before_one_rounds(id, parent_id, round_type, question_id, conditional_bundles) VALUES(66, 0, 'single', 1, FALSE);



INSERT INTO after_two_rounds(round_id) VALUES(1);
INSERT INTO after_two_rounds(round_id) VALUES(3);
INSERT INTO after_two_rounds(round_id) VALUES(6);
INSERT INTO after_two_rounds(round_id) VALUES(8);
INSERT INTO after_two_rounds(round_id) VALUES(11);
INSERT INTO after_two_rounds(round_id) VALUES(13);
INSERT INTO after_two_rounds(round_id) VALUES(15);
INSERT INTO after_two_rounds(round_id) VALUES(17);
INSERT INTO after_two_rounds(round_id) VALUES(19);
INSERT INTO after_two_rounds(round_id) VALUES(21);
INSERT INTO after_two_rounds(round_id) VALUES(23);
INSERT INTO after_two_rounds(round_id) VALUES(25);
INSERT INTO after_two_rounds(round_id) VALUES(32);
INSERT INTO after_two_rounds(round_id) VALUES(35);
INSERT INTO after_two_rounds(round_id) VALUES(37);
INSERT INTO after_two_rounds(round_id) VALUES(39);
INSERT INTO after_two_rounds(round_id) VALUES(42);
INSERT INTO after_two_rounds(round_id) VALUES(44);
INSERT INTO after_two_rounds(round_id) VALUES(46);
INSERT INTO after_two_rounds(round_id) VALUES(49);
INSERT INTO after_two_rounds(round_id) VALUES(51);
INSERT INTO after_two_rounds(round_id) VALUES(53);
INSERT INTO after_two_rounds(round_id) VALUES(55);
INSERT INTO after_two_rounds(round_id) VALUES(57);
INSERT INTO after_two_rounds(round_id) VALUES(59);
INSERT INTO after_two_rounds(round_id) VALUES(61);
INSERT INTO after_two_rounds(round_id) VALUES(63);

INSERT INTO before_two_rounds(id, round_id) VALUES(1, 1);
INSERT INTO before_two_rounds(id, round_id) VALUES(2, 3);
INSERT INTO before_two_rounds(id, round_id) VALUES(3, 6);
INSERT INTO before_two_rounds(id, round_id) VALUES(4, 8);
INSERT INTO before_two_rounds(id, round_id) VALUES(5, 11);
INSERT INTO before_two_rounds(id, round_id) VALUES(6, 13);
INSERT INTO before_two_rounds(id, round_id) VALUES(7, 15);
INSERT INTO before_two_rounds(id, round_id) VALUES(8, 17);
INSERT INTO before_two_rounds(id, round_id) VALUES(9, 19);
INSERT INTO before_two_rounds(id, round_id) VALUES(10, 22);
INSERT INTO before_two_rounds(id, round_id) VALUES(11, 30);
INSERT INTO before_two_rounds(id, round_id) VALUES(12, 33);
INSERT INTO before_two_rounds(id, round_id) VALUES(13, 35);
INSERT INTO before_two_rounds(id, round_id) VALUES(14, 37);
INSERT INTO before_two_rounds(id, round_id) VALUES(15, 40);
INSERT INTO before_two_rounds(id, round_id) VALUES(16, 42);
INSERT INTO before_two_rounds(id, round_id) VALUES(17, 44);
INSERT INTO before_two_rounds(id, round_id) VALUES(18, 47);
INSERT INTO before_two_rounds(id, round_id) VALUES(19, 49);
INSERT INTO before_two_rounds(id, round_id) VALUES(20, 51);
INSERT INTO before_two_rounds(id, round_id) VALUES(21, 53);
INSERT INTO before_two_rounds(id, round_id) VALUES(22, 55);

select "Add Bundles";
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(1, 1, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(2, 1, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(3, 1, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(4, 2, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(5, 2, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(6, 2, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(7, 3, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(8, 3, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(9, 3, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(10, 4, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(11, 4, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(12, 4, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(13, 5, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(14, 5, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(15, 6, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(16, 6, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(17, 6, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(18, 7, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(19, 7, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(20, 7, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(21, 8, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(22, 8, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(23, 8, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(24, 9, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(25, 9, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(26, 9, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(27, 10, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(28, 10, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(29, 11, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(30, 11, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(31, 11, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(32, 12, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(33, 12, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(34, 12, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(35, 13, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(36, 13, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(37, 13, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(38, 14, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(39, 14, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(40, 14, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(41, 15, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(42, 15, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(43, 15, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(44, 16, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(45, 16, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(46, 16, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(47, 17, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(48, 17, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(49, 17, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(50, 18, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(51, 18, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(52, 18, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(53, 19, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(54, 19, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(55, 19, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(56, 19, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(57, 20, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(58, 20, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(59, 20, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(60, 20, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(61, 21, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(62, 21, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(63, 21, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(64, 21, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(65, 22, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(66, 22, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(67, 22, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(68, 22, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(69, 23, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(70, 23, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(71, 23, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(72, 23, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(73, 24, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(74, 24, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(75, 24, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(76, 24, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(77, 25, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(78, 25, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(79, 25, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(80, 25, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(81, 26, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(82, 26, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(83, 26, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(84, 26, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(85, 27, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(86, 27, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(87, 28, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(88, 28, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(89, 29, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(90, 29, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(91, 30, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(92, 30, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(93, 31, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(94, 31, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(95, 32, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(96, 32, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(97, 32, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(98, 33, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(99, 33, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(100, 33, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(101, 34, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(102, 34, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(103, 35, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(104, 35, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(105, 35, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(106, 36, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(107, 36, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(108, 36, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(109, 37, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(110, 37, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(111, 37, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(112, 38, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(113, 38, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(114, 38, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(115, 39, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(116, 39, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(117, 39, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(118, 40, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(119, 40, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(120, 40, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(121, 41, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(122, 41, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(123, 42, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(124, 42, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(125, 42, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(126, 43, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(127, 43, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(128, 43, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(129, 44, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(130, 44, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(131, 44, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(132, 45, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(133, 45, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(134, 45, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(135, 46, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(136, 46, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(137, 46, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(138, 47, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(139, 47, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(140, 47, FALSE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(141, 48, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(142, 48, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(143, 49, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(144, 49, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(145, 49, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(146, 49, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(147, 50, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(148, 50, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(149, 50, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(150, 50, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(151, 51, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(152, 51, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(153, 51, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(154, 52, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(155, 52, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(156, 52, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(157, 53, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(158, 53, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(159, 53, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(160, 54, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(161, 54, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(162, 54, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(163, 55, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(164, 55, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(165, 55, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(166, 56, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(167, 56, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(168, 56, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(169, 57, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(170, 57, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(171, 57, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(172, 58, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(173, 58, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(174, 58, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(175, 59, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(176, 59, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(177, 59, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(178, 59, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(179, 60, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(180, 60, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(181, 60, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(182, 60, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(183, 61, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(184, 61, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(185, 61, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(186, 61, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(187, 62, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(188, 62, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(189, 62, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(190, 62, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(191, 63, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(192, 63, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(193, 63, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(194, 63, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(195, 64, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(196, 64, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(197, 64, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(198, 64, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(199, 65, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(200, 65, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(201, 66, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(202, 66, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(203, 67, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(204, 67, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(205, 68, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(206, 68, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(207, 69, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(208, 69, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(209, 70, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(210, 70, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(211, 71, TRUE);
INSERT INTO after_one_bundles(id, round_id, availability) VALUES(212, 71, TRUE);


INSERT INTO before_one_bundles(id, round_id, availability) VALUES(1, 1, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(2, 1, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(3, 1, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(4, 2, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(5, 2, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(6, 2, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(7, 3, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(8, 3, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(9, 3, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(10, 4, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(11, 4, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(12, 4, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(13, 5, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(14, 5, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(15, 6, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(16, 6, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(17, 6, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(18, 7, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(19, 7, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(20, 7, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(21, 8, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(22, 8, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(23, 8, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(24, 9, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(25, 9, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(26, 9, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(27, 10, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(28, 10, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(29, 11, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(30, 11, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(31, 11, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(32, 12, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(33, 12, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(34, 12, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(35, 13, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(36, 13, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(37, 13, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(38, 14, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(39, 14, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(40, 14, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(41, 15, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(42, 15, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(43, 15, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(44, 16, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(45, 16, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(46, 16, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(47, 17, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(48, 17, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(49, 17, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(50, 18, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(51, 18, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(52, 18, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(53, 19, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(54, 19, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(55, 19, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(56, 19, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(57, 20, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(58, 20, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(59, 20, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(60, 20, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(61, 21, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(62, 21, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(63, 21, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(64, 21, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(65, 22, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(66, 22, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(67, 22, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(68, 22, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(69, 23, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(70, 23, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(71, 23, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(72, 23, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(73, 24, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(74, 24, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(75, 24, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(76, 24, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(77, 25, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(78, 25, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(79, 26, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(80, 26, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(81, 27, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(82, 27, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(83, 28, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(84, 28, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(85, 29, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(86, 29, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(87, 30, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(88, 30, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(89, 30, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(90, 31, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(91, 31, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(92, 31, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(93, 32, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(94, 32, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(95, 33, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(96, 33, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(97, 33, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(98, 34, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(99, 34, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(100, 34, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(101, 35, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(102, 35, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(103, 35, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(104, 36, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(105, 36, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(106, 36, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(107, 37, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(108, 37, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(109, 37, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(110, 38, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(111, 38, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(112, 38, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(113, 39, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(114, 39, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(115, 40, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(116, 40, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(117, 40, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(118, 41, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(119, 41, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(120, 41, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(121, 42, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(122, 42, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(123, 42, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(124, 43, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(125, 43, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(126, 43, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(127, 44, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(128, 44, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(129, 44, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(130, 45, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(131, 45, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(132, 45, FALSE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(133, 46, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(134, 46, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(135, 47, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(136, 47, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(137, 47, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(138, 47, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(139, 48, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(140, 48, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(141, 48, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(142, 48, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(143, 49, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(144, 49, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(145, 49, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(146, 50, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(147, 50, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(148, 50, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(149, 51, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(150, 51, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(151, 51, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(152, 52, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(153, 52, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(154, 52, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(155, 53, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(156, 53, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(157, 53, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(158, 54, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(159, 54, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(160, 54, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(161, 55, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(162, 55, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(163, 55, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(164, 56, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(165, 56, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(166, 56, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(167, 57, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(168, 57, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(169, 57, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(170, 57, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(171, 58, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(172, 58, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(173, 58, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(174, 58, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(175, 59, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(176, 59, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(177, 59, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(178, 59, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(179, 60, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(180, 60, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(181, 61, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(182, 61, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(183, 62, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(184, 62, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(185, 63, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(186, 63, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(187, 64, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(188, 64, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(189, 65, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(190, 65, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(191, 66, TRUE);
INSERT INTO before_one_bundles(id, round_id, availability) VALUES(192, 66, TRUE);



select "Add Items";
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(1, 1, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(2, 1, 5, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(3, 2, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(4, 2, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(5, 3, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(6, 3, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(7, 4, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(8, 4, 5, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(9, 5, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(10, 5, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(11, 6, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(12, 6, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(13, 7, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(14, 7, 5, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(15, 8, 4, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(16, 8, 2, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(17, 9, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(18, 9, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(19, 10, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(20, 10, 5, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(21, 11, 4, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(22, 11, 2, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(23, 12, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(24, 12, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(25, 13, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(26, 13, 5, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(27, 14, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(28, 14, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(29, 15, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(30, 15, 10, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(31, 16, 4, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(32, 16, 8, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(33, 17, 10, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(34, 17, 2, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(35, 18, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(36, 18, 10, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(37, 19, 4, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(38, 19, 8, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(39, 20, 10, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(40, 20, 2, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(41, 21, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(42, 21, 10, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(43, 22, 8, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(44, 22, 4, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(45, 23, 10, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(46, 23, 2, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(47, 24, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(48, 24, 10, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(49, 25, 8, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(50, 25, 4, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(51, 26, 10, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(52, 26, 2, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(53, 27, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(54, 27, 10, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(55, 28, 10, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(56, 28, 2, 'Stamps');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(57, 29, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(58, 29, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(59, 30, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(60, 30, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(61, 31, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(62, 31, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(63, 32, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(64, 32, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(65, 33, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(66, 33, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(67, 34, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(68, 34, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(69, 35, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(70, 35, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(71, 36, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(72, 36, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(73, 37, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(74, 37, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(75, 38, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(76, 38, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(77, 39, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(78, 39, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(79, 40, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(80, 40, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(81, 41, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(82, 41, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(83, 42, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(84, 42, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(85, 43, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(86, 43, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(87, 44, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(88, 44, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(89, 45, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(90, 45, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(91, 46, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(92, 46, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(93, 47, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(94, 47, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(95, 48, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(96, 48, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(97, 49, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(98, 49, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(99, 50, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(100, 50, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(101, 51, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(102, 51, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(103, 52, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(104, 52, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(105, 53, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(106, 53, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(107, 54, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(108, 54, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(109, 55, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(110, 55, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(111, 56, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(112, 56, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(113, 57, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(114, 57, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(115, 58, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(116, 58, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(117, 59, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(118, 59, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(119, 60, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(120, 60, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(121, 61, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(122, 61, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(123, 62, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(124, 62, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(125, 63, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(126, 63, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(127, 64, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(128, 64, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(129, 65, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(130, 65, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(131, 66, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(132, 66, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(133, 67, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(134, 67, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(135, 68, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(136, 68, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(137, 69, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(138, 69, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(139, 70, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(140, 70, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(141, 71, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(142, 71, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(143, 72, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(144, 72, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(145, 73, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(146, 73, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(147, 74, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(148, 74, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(149, 75, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(150, 75, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(151, 76, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(152, 76, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(153, 77, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(154, 77, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(155, 78, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(156, 78, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(157, 79, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(158, 79, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(159, 80, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(160, 80, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(161, 81, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(162, 81, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(163, 82, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(164, 82, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(165, 83, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(166, 83, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(167, 84, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(168, 84, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(169, 85, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(170, 85, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(171, 86, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(172, 86, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(173, 87, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(174, 87, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(175, 88, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(176, 88, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(177, 89, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(178, 89, 3, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(179, 90, 6, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(180, 90, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(181, 91, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(182, 91, 4, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(183, 92, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(184, 92, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(185, 93, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(186, 93, 6, 'Folders');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(187, 94, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(188, 94, 1, 'Folder');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(189, 95, 1, 'Pack of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(190, 95, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(191, 96, 9, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(192, 96, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(193, 97, 10, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(194, 97, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(195, 98, 1, 'Pack of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(196, 98, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(197, 99, 9, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(198, 99, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(199, 100, 10, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(200, 100, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(201, 101, 1, 'Pack of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(202, 101, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(203, 102, 10, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(204, 102, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(205, 103, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(206, 103, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(207, 104, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(208, 104, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(209, 105, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(210, 105, 4, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(211, 106, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(212, 106, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(213, 107, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(214, 107, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(215, 108, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(216, 108, 4, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(217, 109, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(218, 109, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(219, 110, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(220, 110, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(221, 111, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(222, 111, 2, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(223, 112, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(224, 112, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(225, 113, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(226, 113, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(227, 114, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(228, 114, 2, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(229, 115, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(230, 115, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(231, 116, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(232, 116, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(233, 117, 4, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(234, 117, 2, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(235, 118, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(236, 118, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(237, 119, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(238, 119, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(239, 120, 4, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(240, 120, 2, 'stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(241, 121, 1, 'Bar of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(242, 121, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(243, 122, 2, 'Bars of Chocolate');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(244, 122, 1, 'Sticker');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(245, 123, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(246, 123, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(247, 124, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(248, 124, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(249, 125, 4, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(250, 125, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(251, 126, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(252, 126, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(253, 127, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(254, 127, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(255, 128, 4, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(256, 128, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(257, 129, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(258, 129, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(259, 130, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(260, 130, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(261, 131, 3, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(262, 131, 6, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(263, 132, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(264, 132, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(265, 133, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(266, 133, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(267, 134, 3, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(268, 134, 6, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(269, 135, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(270, 135, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(271, 136, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(272, 136, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(273, 137, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(274, 137, 8, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(275, 138, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(276, 138, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(277, 139, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(278, 139, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(279, 140, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(280, 140, 8, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(281, 141, 2, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(282, 141, 2, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(283, 142, 1, 'Pen');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(284, 142, 4, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(285, 143, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(286, 143, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(287, 143, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(288, 144, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(289, 144, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(290, 144, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(291, 145, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(292, 145, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(293, 145, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(294, 146, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(295, 146, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(296, 146, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(297, 147, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(298, 147, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(299, 147, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(300, 148, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(301, 148, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(302, 148, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(303, 149, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(304, 149, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(305, 149, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(306, 150, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(307, 150, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(308, 150, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(309, 151, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(310, 151, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(311, 151, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(312, 152, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(313, 152, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(314, 152, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(315, 153, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(316, 153, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(317, 153, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(318, 154, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(319, 154, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(320, 154, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(321, 155, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(322, 155, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(323, 155, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(324, 156, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(325, 156, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(326, 156, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(327, 157, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(328, 157, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(329, 157, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(330, 158, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(331, 158, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(332, 158, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(333, 159, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(334, 159, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(335, 159, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(336, 160, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(337, 160, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(338, 160, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(339, 161, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(340, 161, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(341, 161, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(342, 162, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(343, 162, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(344, 162, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(345, 163, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(346, 163, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(347, 163, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(348, 164, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(349, 164, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(350, 164, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(351, 165, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(352, 165, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(353, 165, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(354, 166, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(355, 166, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(356, 166, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(357, 167, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(358, 167, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(359, 167, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(360, 168, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(361, 168, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(362, 168, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(363, 169, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(364, 169, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(365, 169, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(366, 170, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(367, 170, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(368, 170, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(369, 171, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(370, 171, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(371, 171, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(372, 172, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(373, 172, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(374, 172, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(375, 173, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(376, 173, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(377, 173, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(378, 174, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(379, 174, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(380, 174, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(381, 175, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(382, 175, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(383, 175, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(384, 176, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(385, 176, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(386, 176, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(387, 177, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(388, 177, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(389, 177, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(390, 178, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(391, 178, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(392, 178, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(393, 179, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(394, 179, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(395, 179, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(396, 180, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(397, 180, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(398, 180, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(399, 181, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(400, 181, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(401, 181, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(402, 182, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(403, 182, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(404, 182, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(405, 183, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(406, 183, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(407, 183, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(408, 184, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(409, 184, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(410, 184, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(411, 185, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(412, 185, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(413, 185, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(414, 186, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(415, 186, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(416, 186, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(417, 187, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(418, 187, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(419, 187, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(420, 188, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(421, 188, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(422, 188, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(423, 189, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(424, 189, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(425, 189, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(426, 190, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(427, 190, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(428, 190, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(429, 191, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(430, 191, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(431, 191, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(432, 192, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(433, 192, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(434, 192, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(435, 193, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(436, 193, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(437, 193, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(438, 194, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(439, 194, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(440, 194, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(441, 195, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(442, 195, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(443, 195, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(444, 196, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(445, 196, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(446, 196, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(447, 197, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(448, 197, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(449, 197, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(450, 198, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(451, 198, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(452, 198, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(453, 199, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(454, 199, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(455, 199, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(456, 200, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(457, 200, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(458, 200, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(459, 201, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(460, 201, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(461, 201, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(462, 202, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(463, 202, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(464, 202, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(465, 203, 5, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(466, 203, 1, 'Key Chain');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(467, 203, 3, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(468, 204, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(469, 204, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(470, 204, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(471, 205, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(472, 205, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(473, 205, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(474, 206, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(475, 206, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(476, 206, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(477, 207, 2, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(478, 207, 4, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(479, 207, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(480, 208, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(481, 208, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(482, 208, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(483, 209, 6, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(484, 209, 3, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(485, 209, 2, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(486, 210, 3, 'Postcards');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(487, 210, 2, 'Key Chains');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(488, 210, 4, 'Stickers');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(489, 211, 9, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(490, 211, 5, 'Pens');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(491, 212, 10, 'Packs of Gum');
INSERT INTO after_one_items(id, bundle_id, item_number, item_type) VALUES(492, 212, 1, 'Pen');



INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(1, 1, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(2, 1, 5, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(3, 2, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(4, 2, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(5, 3, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(6, 3, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(7, 4, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(8, 4, 5, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(9, 5, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(10, 5, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(11, 6, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(12, 6, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(13, 7, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(14, 7, 5, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(15, 8, 4, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(16, 8, 2, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(17, 9, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(18, 9, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(19, 10, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(20, 10, 5, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(21, 11, 4, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(22, 11, 2, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(23, 12, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(24, 12, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(25, 13, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(26, 13, 5, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(27, 14, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(28, 14, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(29, 15, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(30, 15, 10, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(31, 16, 4, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(32, 16, 8, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(33, 17, 10, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(34, 17, 2, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(35, 18, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(36, 18, 10, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(37, 19, 4, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(38, 19, 8, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(39, 20, 10, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(40, 20, 2, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(41, 21, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(42, 21, 10, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(43, 22, 8, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(44, 22, 4, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(45, 23, 10, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(46, 23, 2, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(47, 24, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(48, 24, 10, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(49, 25, 8, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(50, 25, 4, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(51, 26, 10, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(52, 26, 2, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(53, 27, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(54, 27, 10, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(55, 28, 10, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(56, 28, 2, 'Stamps');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(57, 29, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(58, 29, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(59, 30, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(60, 30, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(61, 31, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(62, 31, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(63, 32, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(64, 32, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(65, 33, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(66, 33, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(67, 34, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(68, 34, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(69, 35, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(70, 35, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(71, 36, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(72, 36, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(73, 37, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(74, 37, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(75, 38, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(76, 38, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(77, 39, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(78, 39, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(79, 40, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(80, 40, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(81, 41, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(82, 41, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(83, 42, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(84, 42, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(85, 43, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(86, 43, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(87, 44, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(88, 44, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(89, 45, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(90, 45, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(91, 46, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(92, 46, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(93, 47, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(94, 47, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(95, 48, 1, 'Key Chain ');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(96, 48, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(97, 49, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(98, 49, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(99, 50, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(100, 50, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(101, 51, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(102, 51, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(103, 52, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(104, 52, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(105, 53, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(106, 53, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(107, 54, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(108, 54, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(109, 55, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(110, 55, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(111, 56, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(112, 56, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(113, 57, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(114, 57, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(115, 58, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(116, 58, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(117, 59, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(118, 59, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(119, 60, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(120, 60, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(121, 61, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(122, 61, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(123, 62, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(124, 62, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(125, 63, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(126, 63, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(127, 64, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(128, 64, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(129, 65, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(130, 65, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(131, 66, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(132, 66, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(133, 67, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(134, 67, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(135, 68, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(136, 68, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(137, 69, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(138, 69, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(139, 70, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(140, 70, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(141, 71, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(142, 71, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(143, 72, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(144, 72, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(145, 73, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(146, 73, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(147, 74, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(148, 74, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(149, 75, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(150, 75, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(151, 76, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(152, 76, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(153, 77, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(154, 77, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(155, 78, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(156, 78, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(157, 79, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(158, 79, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(159, 80, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(160, 80, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(161, 81, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(162, 81, 3, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(163, 82, 6, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(164, 82, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(165, 83, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(166, 83, 4, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(167, 84, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(168, 84, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(169, 85, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(170, 85, 6, 'Folders');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(171, 86, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(172, 86, 1, 'Folder');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(173, 87, 1, 'Pack of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(174, 87, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(175, 88, 9, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(176, 88, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(177, 89, 10, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(178, 89, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(179, 90, 1, 'Pack of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(180, 90, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(181, 91, 9, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(182, 91, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(183, 92, 10, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(184, 92, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(185, 93, 1, 'Pack of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(186, 93, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(187, 94, 10, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(188, 94, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(189, 95, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(190, 95, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(191, 96, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(192, 96, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(193, 97, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(194, 97, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(195, 98, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(196, 98, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(197, 99, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(198, 99, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(199, 100, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(200, 100, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(201, 101, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(202, 101, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(203, 102, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(204, 102, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(205, 103, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(206, 103, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(207, 104, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(208, 104, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(209, 105, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(210, 105, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(211, 106, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(212, 106, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(213, 107, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(214, 107, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(215, 108, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(216, 108, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(217, 109, 4, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(218, 109, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(219, 110, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(220, 110, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(221, 111, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(222, 111, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(223, 112, 4, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(224, 112, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(225, 113, 1, 'Bar of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(226, 113, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(227, 114, 2, 'Bars of Chocolate');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(228, 114, 1, 'Sticker');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(229, 115, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(230, 115, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(231, 116, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(232, 116, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(233, 117, 4, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(234, 117, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(235, 118, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(236, 118, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(237, 119, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(238, 119, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(239, 120, 4, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(240, 120, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(241, 121, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(242, 121, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(243, 122, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(244, 122, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(245, 123, 3, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(246, 123, 6, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(247, 124, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(248, 124, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(249, 125, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(250, 125, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(251, 126, 3, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(252, 126, 6, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(253, 127, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(254, 127, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(255, 128, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(256, 128, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(257, 129, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(258, 129, 8, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(259, 130, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(260, 130, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(261, 131, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(262, 131, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(263, 132, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(264, 132, 8, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(265, 133, 2, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(266, 133, 2, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(267, 134, 1, 'Pen');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(268, 134, 4, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(269, 135, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(270, 135, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(271, 135, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(272, 136, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(273, 136, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(274, 136, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(275, 137, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(276, 137, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(277, 137, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(278, 138, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(279, 138, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(280, 138, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(281, 139, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(282, 139, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(283, 139, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(284, 140, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(285, 140, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(286, 140, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(287, 141, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(288, 141, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(289, 141, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(290, 142, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(291, 142, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(292, 142, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(293, 143, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(294, 143, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(295, 143, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(296, 144, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(297, 144, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(298, 144, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(299, 145, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(300, 145, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(301, 145, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(302, 146, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(303, 146, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(304, 146, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(305, 147, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(306, 147, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(307, 147, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(308, 148, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(309, 148, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(310, 148, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(311, 149, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(312, 149, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(313, 149, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(314, 150, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(315, 150, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(316, 150, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(317, 151, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(318, 151, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(319, 151, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(320, 152, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(321, 152, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(322, 152, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(323, 153, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(324, 153, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(325, 153, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(326, 154, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(327, 154, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(328, 154, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(329, 155, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(330, 155, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(331, 155, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(332, 156, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(333, 156, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(334, 156, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(335, 157, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(336, 157, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(337, 157, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(338, 158, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(339, 158, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(340, 158, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(341, 159, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(342, 159, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(343, 159, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(344, 160, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(345, 160, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(346, 160, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(347, 161, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(348, 161, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(349, 161, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(350, 162, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(351, 162, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(352, 162, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(353, 163, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(354, 163, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(355, 163, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(356, 164, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(357, 164, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(358, 164, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(359, 165, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(360, 165, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(361, 165, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(362, 166, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(363, 166, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(364, 166, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(365, 167, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(366, 167, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(367, 167, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(368, 168, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(369, 168, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(370, 168, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(371, 169, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(372, 169, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(373, 169, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(374, 170, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(375, 170, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(376, 170, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(377, 171, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(378, 171, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(379, 171, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(380, 172, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(381, 172, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(382, 172, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(383, 173, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(384, 173, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(385, 173, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(386, 174, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(387, 174, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(388, 174, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(389, 175, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(390, 175, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(391, 175, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(392, 176, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(393, 176, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(394, 176, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(395, 177, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(396, 177, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(397, 177, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(398, 178, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(399, 178, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(400, 178, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(401, 179, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(402, 179, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(403, 179, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(404, 180, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(405, 180, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(406, 180, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(407, 181, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(408, 181, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(409, 181, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(410, 182, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(411, 182, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(412, 182, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(413, 183, 5, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(414, 183, 1, 'Key Chain');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(415, 183, 3, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(416, 184, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(417, 184, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(418, 184, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(419, 185, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(420, 185, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(421, 185, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(422, 186, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(423, 186, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(424, 186, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(425, 187, 2, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(426, 187, 4, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(427, 187, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(428, 188, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(429, 188, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(430, 188, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(431, 189, 6, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(432, 189, 3, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(433, 189, 2, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(434, 190, 3, 'Postcards');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(435, 190, 2, 'Key Chains');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(436, 190, 4, 'Stickers');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(437, 191, 9, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(438, 191, 5, 'Pens');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(439, 192, 10, 'Packs of Gum');
INSERT INTO before_one_items(id, bundle_id, item_number, item_type) VALUES(440, 192, 1, 'Pen');
