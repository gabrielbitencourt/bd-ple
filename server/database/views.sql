SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_crfforms_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_crfforms_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_crfforms_covidcrfrapid` (
  `crfFormsID` int(10),
  `questionnaireID` int(10),
  `description` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_listofvalues_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_listofvalues_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_listofvalues_covidcrfrapid` (
  `listOfValuesID` int(10),
  `listTypeID` int(10),
  `description` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_listype_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_listype_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_listype_covidcrfrapid` (
  `listTypeID` int(10),
  `description` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_questiongroupform_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_questiongroupform_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_questiongroupform_covidcrfrapid` (
  `crfFormsID` int(10),
  `questionID` int(10),
  `questionOrder` int(10),
  `form_OntologyURI` varchar(500),
  `question_OntologyURI` varchar(500)
);

DROP VIEW IF EXISTS `vw_questiongroup_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_questiongroup_covidcrfrapid` (
  `questionGroupID` int(10),
  `description` varchar(255),
  `comment` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_questionnaire_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_questionnaire_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_questionnaire_covidcrfrapid` (
  `questionnaireID` int(10),
  `description` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_questions_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_questions_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_questions_covidcrfrapid` (
  `questionID` int(10),
  `description` varchar(255),
  `questionTypeID` int(10),
  `listTypeID` int(10),
  `questionGroupID` int(10),
  `subordinateTo` int(10),
  `isAbout` int(10),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `vw_questiontype_covidcrfrapid`
-- (Veja abaixo para a view atual)
--
DROP VIEW IF EXISTS `vw_questiontype_covidcrfrapid`;
CREATE TABLE IF NOT EXISTS `vw_questiontype_covidcrfrapid` (
  `questionTypeID` int(10),
  `description` varchar(255),
  `ontologyURI` varchar(500)
);

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_crfforms_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_crfforms_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_crfforms_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_crfforms_covidcrfrapid`  AS  select `t1`.`crfFormsID` AS `crfFormsID`,`t1`.`questionnaireID` AS `questionnaireID`,`t1`.`description` AS `description`,`ontologyURI`('COVIDCRFRAPID','tb_crfforms',`t1`.`crfFormsID`) AS `ontologyURI` from `tb_crfforms` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_listofvalues_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_listofvalues_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_listofvalues_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listofvalues_covidcrfrapid`  AS  select `t1`.`listOfValuesID` AS `listOfValuesID`,`t1`.`listTypeID` AS `listTypeID`,`t1`.`description` AS `description`,`ontologyURI`('COVIDCRFRAPID','tb_listofvalues',`t1`.`listOfValuesID`) AS `ontologyURI` from `tb_listofvalues` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_listype_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_listype_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_listype_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listype_covidcrfrapid`  AS  select `t1`.`listTypeID` AS `listTypeID`,`t1`.`description` AS `description`,`ontologyURI`('COVIDCRFRAPID','tb_listtype',`t1`.`listTypeID`) AS `ontologyURI` from `tb_listtype` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_questiongroupform_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_questiongroupform_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_questiongroupform_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_questiongroupform_covidcrfrapid`  AS  select `t1`.`crfFormsID` AS `crfFormsID`,`t1`.`questionID` AS `questionID`,`t1`.`questionOrder` AS `questionOrder`,`t2`.`ontologyURI` AS `form_OntologyURI`,`t3`.`ontologyURI` AS `question_OntologyURI` from ((`tb_questiongroupform` `t1` join `vw_crfforms_covidcrfrapid` `t2`) join `vw_questions_covidcrfrapid` `t3`) where ((`t2`.`crfFormsID` = `t1`.`crfFormsID`) and (`t3`.`questionID` = `t1`.`questionID`)) ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_questiongroup_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_questiongroup_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_questiongroup_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_questiongroup_covidcrfrapid`  AS  select `t1`.`questionGroupID` AS `questionGroupID`,`t1`.`description` AS `description`,`t1`.`comment` AS `comment`,`ontologyURI`('COVIDCRFRAPID','tb_questiongroup',`t1`.`questionGroupID`) AS `ontologyURI` from `tb_questiongroup` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_questionnaire_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_questionnaire_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_questionnaire_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_questionnaire_covidcrfrapid`  AS  select `t1`.`questionnaireID` AS `questionnaireID`,`t1`.`description` AS `description`,`ontologyURI`('COVIDCRFRAPID','tb_questionnaire',`t1`.`questionnaireID`) AS `ontologyURI` from `tb_questionnaire` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_questions_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_questions_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_questions_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_questions_covidcrfrapid`  AS  select `t1`.`questionID` AS `questionID`,`t1`.`description` AS `description`,`t1`.`questionTypeID` AS `questionTypeID`,`t1`.`listTypeID` AS `listTypeID`,`t1`.`questionGroupID` AS `questionGroupID`,`t1`.`subordinateTo` AS `subordinateTo`,`t1`.`isAbout` AS `isAbout`,`ontologyURI`('COVIDCRFRAPID','tb_questions',`t1`.`questionID`) AS `ontologyURI` from `tb_questions` `t1` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `vw_questiontype_covidcrfrapid`
--
DROP TABLE IF EXISTS `vw_questiontype_covidcrfrapid`;

DROP VIEW IF EXISTS `vw_questiontype_covidcrfrapid`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_questiontype_covidcrfrapid`  AS  select `t1`.`questionTypeID` AS `questionTypeID`,`t1`.`description` AS `description`,`ontologyURI`('COVIDCRFRAPID','tb_questiontype',`t1`.`questionTypeID`) AS `ontologyURI` from `tb_questiontype` `t1` ;
COMMIT;
