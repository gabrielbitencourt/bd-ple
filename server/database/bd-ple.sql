-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 13/11/2020 às 01:26
-- Versão do servidor: 5.7.25
-- Versão do PHP: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `bd-ple`
--
CREATE DATABASE IF NOT EXISTS `bd-ple` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `bd-ple`;

DELIMITER $$
--
-- Procedimentos
--
DROP PROCEDURE IF EXISTS `getqst_rsp_modulo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getqst_rsp_modulo` (`p_crfformid` INTEGER)  BEGIN
 select crfformsid as modId, questionid as qstId,
	      translate('pt-br', questionGroup) as dsc_qst_grp,
		 translate('pt-br', question) as dsc_qst,
	 		    questionType as qst_type,
	            (select  GROUP_CONCAT(translate('pt-br',tlv.description) ORDER BY 1 DESC SEPARATOR ' | ') as listofvalue from tb_listofvalues tlv
                 where listtypeid = tb_Questionario.listtypeid ) as rsp_pad,
	             translate('pt-br', questaosubordinada_a) as sub_qst
		from (
			select crfformsid, questionid, questionorder, 
				   formulario, 
				   (case when questiongroup is null then '' else questiongroup end) as questionGroup,
				   (case when commentquestiongroup is null then '' else commentquestiongroup end) as commentquestiongroup,
				   Question,
				   QuestionType, listTypeResposta, listTypeID, QuestaoSubordinada_A, QuestaoReferente_A
			from (
			select t5.crfformsid, t1.questionid, t9.questionorder,
				   t5.description as formulario,
				   (select t2.description from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as questionGroup,
				   (select t2.comment from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as commentquestionGroup,
					t1.description as question,
				   (select t3.description as questionType from tb_questiontype t3 where t3.questiontypeid = t1.questiontypeid) as questionType,
				   (select t6.description from tb_listType t6 where t6.listtypeid = t1.listtypeid) as listTypeResposta,
				   t1.listtypeid,
				   (select description from tb_questions t7 where t7.questionId = t1.subordinateTo) as QuestaoSubordinada_A,
				   (select description from tb_questions t8 where t8.questionId = t1.isabout) as QuestaoReferente_A
			from tb_questions t1,  tb_crfForms t5, tb_questionGroupForm t9
			where t5.crfformsid = p_crfformid and
			t9.crfformsid = t5.crfformsid and t9.questionid = t1.questionid
			) as tabela_Formulario ) as tb_Questionario
			Order by crfformsid, questionorder;	
END$$

--
-- Funções
--
DROP FUNCTION IF EXISTS `translate`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `translate` (`lng` VARCHAR(500), `val` VARCHAR(500)) RETURNS VARCHAR(500) CHARSET utf8mb4 BEGIN

      declare descriptionLNG varchar (500);

	

	  select t1.descriptionlang into descriptionLNG

      from tb_multilanguage t1, tb_language t2 

	  where t2.description = lng and t1.languageId = t2.languageID and t1.description = val;

  

      if (descriptionLNG is null) then  

	     SET descriptionLNG = '';

	  END IF;

	  

      RETURN descriptionLNG;

      

    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_assessmentquestionnaire`
--

DROP TABLE IF EXISTS `tb_assessmentquestionnaire`;
CREATE TABLE `tb_assessmentquestionnaire` (
  `participantID` int(10) NOT NULL COMMENT '(pt-br)  Chave estrangeira para a tabela tb_Patient.\r\n(en) Foreign key to the tb_Patient table.',
  `hospitalUnitID` int(10) NOT NULL COMMENT '(pt-br) Chave estrangeira para tabela tb_HospitalUnit.\r\n(en) Foreign key for the tp_HospitalUnit table.',
  `questionnaireID` int(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_assessmentquestionnaire`
--

TRUNCATE TABLE `tb_assessmentquestionnaire`;
-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_crfforms`
--

DROP TABLE IF EXISTS `tb_crfforms`;
CREATE TABLE `tb_crfforms` (
  `crfFormsID` int(10) NOT NULL,
  `questionnaireID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição .\r\n(en) description.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='(pt-br)\r\ntb_CRFForms identifica o tipo do formulario refere-se ao Questionnaire Subsection da Ontologia:\r\nAdmissão - Modulo 1\r\nAcompanhamento - Modulo 2\r\nDesfecho - Modulo 3\r\n(en)\r\ntb_CRFForms identifies the type of the form refers to the Questionnaire Subsection of Ontology: Admission - Module 1 Monitoring - Module 2 Outcome - Module 3';

--
-- Tabela truncada antes do insert `tb_crfforms`
--

TRUNCATE TABLE `tb_crfforms`;
--
-- Despejando dados para a tabela `tb_crfforms`
--

INSERT INTO `tb_crfforms` (`crfFormsID`, `questionnaireID`, `description`) VALUES
(1, 1, 'Admission form'),
(2, 1, 'Follow-up'),
(3, 1, 'Discharge/death form');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_formrecord`
--

DROP TABLE IF EXISTS `tb_formrecord`;
CREATE TABLE `tb_formrecord` (
  `formRecordID` int(10) NOT NULL,
  `participantID` int(10) NOT NULL,
  `hospitalUnitID` int(10) NOT NULL,
  `questionnaireID` int(10) NOT NULL,
  `crfFormsID` int(10) NOT NULL,
  `dtRegistroForm` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_formrecord`
--

TRUNCATE TABLE `tb_formrecord`;
-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_grouprole`
--

DROP TABLE IF EXISTS `tb_grouprole`;
CREATE TABLE `tb_grouprole` (
  `groupRoleID` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_grouprole`
--

TRUNCATE TABLE `tb_grouprole`;
--
-- Despejando dados para a tabela `tb_grouprole`
--

INSERT INTO `tb_grouprole` (`groupRoleID`, `description`) VALUES
(1, 'Administrador'),
(2, 'ETL - Arquivos'),
(3, 'ETL - BD a BD'),
(4, 'Gestor de Ontologia'),
(5, 'Gestor de Repositório'),
(6, 'Notificador Médico'),
(7, 'Notificador Profissional de Saúde');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_grouprolepermission`
--

DROP TABLE IF EXISTS `tb_grouprolepermission`;
CREATE TABLE `tb_grouprolepermission` (
  `groupRoleID` int(11) NOT NULL,
  `permissionID` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_grouprolepermission`
--

TRUNCATE TABLE `tb_grouprolepermission`;
--
-- Despejando dados para a tabela `tb_grouprolepermission`
--

INSERT INTO `tb_grouprolepermission` (`groupRoleID`, `permissionID`) VALUES
(1, 4),
(2, 1),
(3, 1),
(4, 4),
(5, 4),
(6, 4),
(7, 1),
(7, 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_hospitalunit`
--

DROP TABLE IF EXISTS `tb_hospitalunit`;
CREATE TABLE `tb_hospitalunit` (
  `hospitalUnitID` int(10) NOT NULL,
  `hospitalUnitName` varchar(500) NOT NULL COMMENT '(pt-br) Nome da unidade hospitalar.\r\n(en) Name of the hospital unit.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='(pt-br) Tabela para identificação de unidades hospitalares.\r\n(en) Table for hospital units identification.';

--
-- Tabela truncada antes do insert `tb_hospitalunit`
--

TRUNCATE TABLE `tb_hospitalunit`;
--
-- Despejando dados para a tabela `tb_hospitalunit`
--

INSERT INTO `tb_hospitalunit` (`hospitalUnitID`, `hospitalUnitName`) VALUES
(1, 'Hospital Exemplo'),
(2, 'Hospital Teste');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_language`
--

DROP TABLE IF EXISTS `tb_language`;
CREATE TABLE `tb_language` (
  `languageID` int(11) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_language`
--

TRUNCATE TABLE `tb_language`;
--
-- Despejando dados para a tabela `tb_language`
--

INSERT INTO `tb_language` (`languageID`, `description`) VALUES
(1, 'pt-br');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_listofvalues`
--

DROP TABLE IF EXISTS `tb_listofvalues`;
CREATE TABLE `tb_listofvalues` (
  `listOfValuesID` int(10) NOT NULL,
  `listTypeID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição.\r\n(en) description.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='(pt-br) Representa todos os valores padronizados do formulário.\r\n(en) Represents all standard values on the form.';

--
-- Tabela truncada antes do insert `tb_listofvalues`
--

TRUNCATE TABLE `tb_listofvalues`;
--
-- Despejando dados para a tabela `tb_listofvalues`
--

INSERT INTO `tb_listofvalues` (`listOfValuesID`, `listTypeID`, `description`) VALUES
(1, 1, 'Interferon alpha'),
(2, 1, 'Interferon beta'),
(3, 1, 'Lopinavir/Ritonavir'),
(4, 1, 'Neuraminidase inhibitor'),
(5, 1, 'Ribavirin'),
(6, 2, 'Alert'),
(7, 2, 'Pain'),
(8, 2, 'Unresponsive'),
(9, 2, 'Verbal'),
(10, 3, 'MERS-CoV'),
(11, 3, 'SARS-CoV-2'),
(12, 4, 'Inhaled'),
(13, 4, 'Intravenous'),
(14, 4, 'Oral'),
(15, 5, 'Afghanistan'),
(16, 5, 'Aland Islands'),
(17, 5, 'Albania'),
(18, 5, 'Algeria'),
(19, 5, 'American Samoa'),
(20, 5, 'Andorra'),
(21, 5, 'Angola'),
(22, 5, 'Anguilla'),
(23, 5, 'Antarctica'),
(24, 5, 'Antigua and Barbuda'),
(25, 5, 'Argentina'),
(26, 5, 'Armenia'),
(27, 5, 'Aruba'),
(28, 5, 'Australia'),
(29, 5, 'Austria'),
(30, 5, 'Azerbaijan'),
(31, 5, 'Bahamas'),
(32, 5, 'Bahrain'),
(33, 5, 'Bangladesh'),
(34, 5, 'Barbados'),
(35, 5, 'Belarus'),
(36, 5, 'Belgium'),
(37, 5, 'Belize'),
(38, 5, 'Benin'),
(39, 5, 'Bermuda'),
(40, 5, 'Bhutan'),
(41, 5, 'Bolivia, Plurinational State of'),
(42, 5, 'Bosnia and Herzegovina'),
(43, 5, 'Botswana'),
(44, 5, 'Bouvet Island'),
(45, 5, 'Brazil'),
(46, 5, 'British Indian Ocean Territory'),
(47, 5, 'Brunei Darussalam'),
(48, 5, 'Bulgaria'),
(49, 5, 'Burkina Faso'),
(50, 5, 'Burundi'),
(51, 5, 'Cambodia'),
(52, 5, 'Cameroon'),
(53, 5, 'Canada'),
(54, 5, 'Cape Verde'),
(55, 5, 'Cayman Islands'),
(56, 5, 'Central African Republic'),
(57, 5, 'Chad'),
(58, 5, 'Chile'),
(59, 5, 'China'),
(60, 5, 'Christmas Island'),
(61, 5, 'Cocos (Keeling) Islands'),
(62, 5, 'Colombia'),
(63, 5, 'Comoros'),
(64, 5, 'Congo'),
(65, 5, 'Congo, the Democratic Republic of the'),
(66, 5, 'Cook Islands'),
(67, 5, 'Costa Rica'),
(68, 5, 'Cote d\'Ivoire'),
(69, 5, 'Croatia'),
(70, 5, 'Cuba'),
(71, 5, 'Cyprus'),
(72, 5, 'Czech Republic'),
(73, 5, 'Denmark'),
(74, 5, 'Djibouti'),
(75, 5, 'Dominica'),
(76, 5, 'Dominican Republic'),
(77, 5, 'Ecuador'),
(78, 5, 'Egypt'),
(79, 5, 'El Salvador'),
(80, 5, 'Equatorial Guinea'),
(81, 5, 'Eritrea'),
(82, 5, 'Estonia'),
(83, 5, 'Ethiopia'),
(84, 5, 'Falkland Islands (Malvinas)'),
(85, 5, 'Faroe Islands'),
(86, 5, 'Fiji'),
(87, 5, 'Finland'),
(88, 5, 'France'),
(89, 5, 'French Guiana'),
(90, 5, 'French Polynesia'),
(91, 5, 'French Southern Territories'),
(92, 5, 'Gabon'),
(93, 5, 'Gambia'),
(94, 5, 'Georgia'),
(95, 5, 'Germany'),
(96, 5, 'Ghana'),
(97, 5, 'Gibraltar'),
(98, 5, 'Greece'),
(99, 5, 'Greenland'),
(100, 5, 'Grenada'),
(101, 5, 'Guadeloupe'),
(102, 5, 'Guam'),
(103, 5, 'Guatemala'),
(104, 5, 'Guernsey'),
(105, 5, 'Guinea'),
(106, 5, 'Guinea-Bissau'),
(107, 5, 'Guyana'),
(108, 5, 'Haiti'),
(109, 5, 'Heard Island and McDonald Islands'),
(110, 5, 'Holy See (Vatican City State)'),
(111, 5, 'Honduras'),
(112, 5, 'Hong Kong'),
(113, 5, 'Hungary'),
(114, 5, 'Iceland'),
(115, 5, 'India'),
(116, 5, 'Indonesia'),
(117, 5, 'Iran, Islamic Republic of'),
(118, 5, 'Iraq'),
(119, 5, 'Ireland'),
(120, 5, 'Isle of Man'),
(121, 5, 'Israel'),
(122, 5, 'Italy'),
(123, 5, 'Jamaica'),
(124, 5, 'Japan'),
(125, 5, 'Jersey'),
(126, 5, 'Jordan'),
(127, 5, 'Kazakhstan'),
(128, 5, 'Kenya'),
(129, 5, 'Kiribati'),
(130, 5, 'Korea, Democratic People\'\'s Republic of'),
(131, 5, 'Korea, Republic of'),
(132, 5, 'Kuwait'),
(133, 5, 'Kyrgyzstan'),
(134, 5, 'Lao People\'s Democratic Republic'),
(135, 5, 'Latvia'),
(136, 5, 'Lebanon'),
(137, 5, 'Lesotho'),
(138, 5, 'Liberia'),
(139, 5, 'Libyan Arab Jamahiriya'),
(140, 5, 'Liechtenstein'),
(141, 5, 'Lithuania'),
(142, 5, 'Luxembourg'),
(143, 5, 'Macao'),
(144, 5, 'Macedonia, the former Yugoslav Republic of'),
(145, 5, 'Madagascar'),
(146, 5, 'Malawi'),
(147, 5, 'Malaysia'),
(148, 5, 'Maldives'),
(149, 5, 'Mali'),
(150, 5, 'Malta'),
(151, 5, 'Marshall Islands'),
(152, 5, 'Martinique'),
(153, 5, 'Mauritania'),
(154, 5, 'Mauritius'),
(155, 5, 'Mayotte'),
(156, 5, 'Mexico'),
(157, 5, 'Micronesia, Federated States of'),
(158, 5, 'Moldova, Republic of'),
(159, 5, 'Monaco'),
(160, 5, 'Mongolia'),
(161, 5, 'Montenegro'),
(162, 5, 'Montserrat'),
(163, 5, 'Morocco'),
(164, 5, 'Mozambique'),
(165, 5, 'Myanmar'),
(166, 5, 'Namibia'),
(167, 5, 'Nauru'),
(168, 5, 'Nepal'),
(169, 5, 'Netherlands'),
(170, 5, 'Netherlands Antilles'),
(171, 5, 'New Caledonia'),
(172, 5, 'New Zealand'),
(173, 5, 'Nicaragua'),
(174, 5, 'Niger'),
(175, 5, 'Nigeria'),
(176, 5, 'Niue'),
(177, 5, 'Norfolk Island'),
(178, 5, 'Northern Mariana Islands'),
(179, 5, 'Norway'),
(180, 5, 'Oman'),
(181, 5, 'Pakistan'),
(182, 5, 'Palau'),
(183, 5, 'Palestinian Territory, Occupied'),
(184, 5, 'Panama'),
(185, 5, 'Papua New Guinea'),
(186, 5, 'Paraguay'),
(187, 5, 'Peru'),
(188, 5, 'Philippines'),
(189, 5, 'Pitcairn'),
(190, 5, 'Poland'),
(191, 5, 'Portugal'),
(192, 5, 'Puerto Rico'),
(193, 5, 'Qatar'),
(194, 5, 'Reunion ﻿ Réunion'),
(195, 5, 'Romania'),
(196, 5, 'Russian Federation'),
(197, 5, 'Rwanda'),
(198, 5, 'Saint Barthélemy'),
(199, 5, 'Saint Helena'),
(200, 5, 'Saint Kitts and Nevis'),
(201, 5, 'Saint Lucia'),
(202, 5, 'Saint Martin (French part)'),
(203, 5, 'Saint Pierre and Miquelon'),
(204, 5, 'Saint Vincent and the Grenadines'),
(205, 5, 'Samoa'),
(206, 5, 'San Marino'),
(207, 5, 'Sao Tome and Principe'),
(208, 5, 'Saudi Arabia'),
(209, 5, 'Senegal'),
(210, 5, 'Serbia'),
(211, 5, 'Seychelles'),
(212, 5, 'Sierra Leone'),
(213, 5, 'Singapore'),
(214, 5, 'Slovakia'),
(215, 5, 'Slovenia'),
(216, 5, 'Solomon Islands'),
(217, 5, 'Somalia'),
(218, 5, 'South Africa'),
(219, 5, 'South Georgia and the South Sandwich Islands'),
(220, 5, 'Spain'),
(221, 5, 'Sri Lanka'),
(222, 5, 'Sudan'),
(223, 5, 'Suriname'),
(224, 5, 'Svalbard and Jan Mayen'),
(225, 5, 'Swaziland'),
(226, 5, 'Sweden'),
(227, 5, 'Switzerland'),
(228, 5, 'Syrian Arab Republic'),
(229, 5, 'Taiwan, Province of China'),
(230, 5, 'Tajikistan'),
(231, 5, 'Tanzania, United Republic of'),
(232, 5, 'Thailand'),
(233, 5, 'Timor-Leste'),
(234, 5, 'Togo'),
(235, 5, 'Tokelau'),
(236, 5, 'Tonga'),
(237, 5, 'Trinidad and Tobago'),
(238, 5, 'Tunisia'),
(239, 5, 'Turkey'),
(240, 5, 'Turkmenistan'),
(241, 5, 'Turks and Caicos Islands'),
(242, 5, 'Tuvalu'),
(243, 5, 'Uganda'),
(244, 5, 'Ukraine'),
(245, 5, 'United Arab Emirates'),
(246, 5, 'United Kingdom'),
(247, 5, 'United States'),
(248, 5, 'United States Minor Outlying Islands'),
(249, 5, 'Uruguay'),
(250, 5, 'Uzbekistan'),
(251, 5, 'Vanuatu'),
(252, 5, 'Venezuela, Bolivarian Republic of'),
(253, 5, 'Viet Nam'),
(254, 5, 'Virgin Islands, British'),
(255, 5, 'Virgin Islands, U.S.'),
(256, 5, 'Wallis and Futuna'),
(257, 5, 'Western Sahara'),
(258, 5, 'Yemen'),
(259, 5, 'Zambia'),
(260, 5, 'Zimbabwe'),
(261, 6, 'No'),
(262, 6, 'Unknown'),
(263, 6, 'Yes-not on ART'),
(264, 6, 'Yes-on ART'),
(265, 7, 'CPAP/NIV mask'),
(266, 7, 'HF nasal cannula'),
(267, 7, 'Mask'),
(268, 7, 'Mask with reservoir'),
(269, 7, 'Unknown'),
(270, 8, '>15 L/min'),
(271, 8, '1-5 L/min'),
(272, 8, '11-15 L/min'),
(273, 8, '6-10 L/min'),
(274, 8, 'Unknown'),
(275, 9, 'Death'),
(276, 9, 'Discharged alive'),
(277, 9, 'Hospitalized'),
(278, 9, 'Palliative discharge'),
(279, 9, 'Transfer to other facility'),
(280, 9, 'Unknown'),
(281, 10, 'Oxygen therapy'),
(282, 10, 'Room air'),
(283, 10, 'Unknown'),
(284, 13, 'Female'),
(285, 13, 'Male'),
(286, 13, 'Not Specified'),
(287, 14, 'Concentrator'),
(288, 14, 'Cylinder'),
(289, 14, 'Piped'),
(290, 14, 'Unknown'),
(291, 11, 'Not done'),
(292, 12, 'Better'),
(293, 12, 'Same as before illness'),
(294, 12, 'Unknown'),
(295, 12, 'Worse'),
(296, 15, 'No'),
(297, 15, 'Unknown'),
(298, 15, 'Yes'),
(299, 16, 'N/A'),
(300, 16, 'No'),
(301, 16, 'Unknown'),
(302, 16, 'Yes'),
(303, 11, 'Negative'),
(304, 11, 'Positive'),
(305, 1, 'Azithromycin'),
(306, 1, 'Chloroquine/hydroxychloroquine'),
(307, 1, 'Favipiravir');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_listtype`
--

DROP TABLE IF EXISTS `tb_listtype`;
CREATE TABLE `tb_listtype` (
  `listTypeID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição.\r\n(en) description.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_listtype`
--

TRUNCATE TABLE `tb_listtype`;
--
-- Despejando dados para a tabela `tb_listtype`
--

INSERT INTO `tb_listtype` (`listTypeID`, `description`) VALUES
(1, 'Antiviral list'),
(2, 'AVPU list'),
(3, 'Coronavirus list'),
(4, 'Corticosteroid list'),
(5, 'Country list'),
(6, 'HIV list'),
(7, 'Interface list'),
(8, 'O2 flow list'),
(9, 'Outcome list'),
(10, 'Outcome saturation list'),
(11, 'pnnotdone_list'),
(12, 'self_care_list'),
(13, 'sex at birth list'),
(14, 'Source of oxygen list'),
(15, 'ynu_list'),
(16, 'ynun_list');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_multilanguage`
--

DROP TABLE IF EXISTS `tb_multilanguage`;
CREATE TABLE `tb_multilanguage` (
  `languageID` int(11) NOT NULL,
  `description` varchar(300) NOT NULL,
  `descriptionLang` varchar(500) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_multilanguage`
--

TRUNCATE TABLE `tb_multilanguage`;
--
-- Despejando dados para a tabela `tb_multilanguage`
--

INSERT INTO `tb_multilanguage` (`languageID`, `description`, `descriptionLang`) VALUES
(1, '>15 L/min', '> 15 L/min'),
(1, '1-5 L/min', '1-5 L/min'),
(1, '11-15 L/min', '11-15 L/min'),
(1, '6-10 L/min', '6-10 L/min'),
(1, 'A class of questions with date answers.', 'Uma classe de perguntas com respostas na forma de data.'),
(1, 'A history of self-reported feverishness or measured fever of ≥ 38 degrees Celsius', 'Um histórico de febre autorelatado ou febre medida de ≥ 38oC'),
(1, 'A question where the possible answers are: Yes, No or Unknown.', 'Uma pergunta onde a resposta pode ser: Sim, Não ou Desconhecido'),
(1, 'A single question of a questionaire. The rdfs:label of the sub-classes reflect the exact questions text from the WHO CRF.', 'Uma pergunta de um questionário. As propriedades rdfs:label das sub-classes refletem exatamente as perguntas definidas no FRC da OMS.'),
(1, 'A term used to indicate that information on a specific question or subject can not be provided because there is no relevance.', 'Termo usado para indicar que a resposta a uma pergunta ou a informação sobre um assunto não pode ser dada porque não é aplicável.'),
(1, 'Abdominal pain', 'Dor abdominal'),
(1, 'Ability to self-care at discharge versus before illness', 'Habilidade de autocuidado na alta em comparação com antes da doença'),
(1, 'Acute renal injury', 'Lesão renal aguda'),
(1, 'Acute Respiratory Distress Syndrome', 'Síndrome Respiratória Aguda'),
(1, 'Admission date at this facility', 'Data de admissão nesta unidade'),
(1, 'Admission form', 'Formulário de Admissão'),
(1, 'Afghanistan', 'Afghanistan'),
(1, 'Age', 'Idade'),
(1, 'Age (months)', 'Idade (meses)'),
(1, 'Age (years)', 'Idade (anos)'),
(1, 'Aland Islands', 'Aland Islands'),
(1, 'Albania', 'Albania'),
(1, 'Alert', 'Alerta'),
(1, 'Algeria', 'Algeria'),
(1, 'ALT/SGPT measurement', 'ALT/TGP'),
(1, 'Altered consciousness/confusion', 'Consciência alterada/confusão'),
(1, 'American Samoa', 'American Samoa'),
(1, 'Anaemia', 'Anemia'),
(1, 'Andorra', 'Andorra'),
(1, 'Angiotensin converting enzyme inhibitors (ACE inhibitors)', 'Inibidores da enzima de conversão da angiotensina (inibidores da ECA)'),
(1, 'Angiotensin II receptor blockers (ARBs)', 'Bloqueadores dos receptores de angiotensina II (BRAs)'),
(1, 'Angola', 'Angola'),
(1, 'Anguilla', 'Anguilla'),
(1, 'Antarctica', 'Antarctica'),
(1, 'Antibiotic', 'Antibiótico'),
(1, 'Antifungal agent', 'Agente antifungal'),
(1, 'Antigua and Barbuda', 'Antigua and Barbuda'),
(1, 'Antimalarial agent', 'Agente antimalárico'),
(1, 'Antiviral', 'Antiviral'),
(1, 'Antiviral list', 'Lista Antiviral'),
(1, 'APTT/APTR measurement', 'TTPA/APTR'),
(1, 'Argentina', 'Argentina'),
(1, 'Armenia', 'Armenia'),
(1, 'Aruba', 'Aruba'),
(1, 'Ashtma', 'Asma'),
(1, 'Asplenia', 'Asplenia'),
(1, 'AST/SGOT measurement', 'AST/TGO'),
(1, 'Australia', 'Australia'),
(1, 'Austria', 'Austria'),
(1, 'AVPU list', 'Lista AVDI'),
(1, 'AVPU scale', 'Escala A V D I'),
(1, 'Azerbaijan', 'Azerbaijan'),
(1, 'Azithromycin', 'Azitromicina'),
(1, 'Bacteraemia', 'Bacteremia'),
(1, 'Bahamas', 'Bahamas'),
(1, 'Bahrain', 'Bahrain'),
(1, 'Bangladesh', 'Bangladesh'),
(1, 'Barbados', 'Barbados'),
(1, 'Belarus', 'Belarus'),
(1, 'Belgium', 'Belgium'),
(1, 'Belize', 'Belize'),
(1, 'Benin', 'Benin'),
(1, 'Bermuda', 'Bermuda'),
(1, 'Better', 'Melhor'),
(1, 'Bhutan', 'Bhutan'),
(1, 'Bleeding', 'Sangramento (hemorragia)'),
(1, 'Bleeding (Haemorrhage)', 'Sangramento (hemorragia)'),
(1, 'Bolivia, Plurinational State of', 'Bolivia, Plurinational State of'),
(1, 'Boolean_Question', 'Questão booleana'),
(1, 'Bosnia and Herzegovina', 'Bosnia and Herzegovina'),
(1, 'Botswana', 'Botswana'),
(1, 'Bouvet Island', 'Bouvet Island'),
(1, 'BP (diastolic)', 'Pressão arterial (diastólica)'),
(1, 'BP (systolic)', 'Pressão arterial (sistólica)'),
(1, 'Brazil', 'Brazil'),
(1, 'British Indian Ocean Territory', 'British Indian Ocean Territory'),
(1, 'Bronchiolitis', 'Bronquiolite'),
(1, 'Brunei Darussalam', 'Brunei Darussalam'),
(1, 'Bulgaria', 'Bulgaria'),
(1, 'Burkina Faso', 'Burkina Faso'),
(1, 'Burundi', 'Burundi'),
(1, 'Cambodia', 'Cambodia'),
(1, 'Cameroon', 'Cameroon'),
(1, 'Canada', 'Canada'),
(1, 'Cape Verde', 'Cape Verde'),
(1, 'Cardiac arrest', 'Parada cardíaca'),
(1, 'Cardiac arrhythmia', 'Arritmia cardíaca'),
(1, 'Cardiomyopathy', 'Cardiomiopatia'),
(1, 'Cayman Islands', 'Cayman Islands'),
(1, 'Central African Republic', 'Central African Republic'),
(1, 'Chad', 'Chad'),
(1, 'Chest pain', 'Dor no peito'),
(1, 'Chest X-Ray /CT performed', 'Radiografia/tomografia computadorizada do tórax feita'),
(1, 'Chile', 'Chile'),
(1, 'China', 'China'),
(1, 'Chloroquine/hydroxychloroquine', 'Cloroquina / hidroxicloroquina'),
(1, 'Christmas Island', 'Christmas Island'),
(1, 'Chronic cardiac disease (not hypertension)', 'Doença cardíaca crônica (não hipertensão)'),
(1, 'Chronic kidney disease', 'Doença renal crônica'),
(1, 'Chronic liver disease', 'Doença hepática crônica'),
(1, 'Chronic neurological disorder', 'Doença neurológica crônica'),
(1, 'Chronic pulmonary disease', 'Doença pulmonar crônica'),
(1, 'Clinical inclusion criteria', 'Critérios Clínicos para Inclusão'),
(1, 'Clinical suspicion of ARI despite not meeting criteria above', 'Suspeita clínica de IRA apesar de não apresentar os sintomas acima'),
(1, 'Co-morbidities', 'Comorbidades'),
(1, 'Cocos (Keeling) Islands', 'Cocos (Keeling) Islands'),
(1, 'Colombia', 'Colombia'),
(1, 'Comoros', 'Comoros'),
(1, 'Complications', 'Complicações'),
(1, 'Concentrator', 'Concentrador'),
(1, 'Confusion', 'Confusão'),
(1, 'Congo', 'Congo'),
(1, 'Congo, the Democratic Republic of the', 'Congo, the Democratic Republic of the'),
(1, 'Conjunctivitis', 'Conjuntivite'),
(1, 'Cook Islands', 'Cook Islands'),
(1, 'Coronavirus', 'Coronavírus'),
(1, 'Coronavirus list', 'Lista Coronavirus'),
(1, 'Corticosteroid', 'Corticosteroide'),
(1, 'Corticosteroid list', 'Lista Corticosteroid'),
(1, 'Costa Rica', 'Costa Rica'),
(1, 'Cote d\'Ivoire', 'Cote d\'Ivoire'),
(1, 'Cough', 'Tosse'),
(1, 'Cough with haemoptysis', 'Tosse com hemóptise'),
(1, 'Cough with sputum', 'Tosse com expectoração'),
(1, 'Cough with sputum production', 'Tosse com expectoração'),
(1, 'Country', 'País'),
(1, 'Country list', 'Lista Paises'),
(1, 'CPAP/NIV mask', 'Máscara CPAP/VNI'),
(1, 'Creatine kinase measurement', 'Creatina quinase'),
(1, 'Creatinine measurement', 'Creatinina'),
(1, 'CRF section grouping questions about clinical inclusion criteria.', 'Parte do FRC que agrupa perguntas sobre os critérios clínicos para inclusão.'),
(1, 'Croatia', 'Croatia'),
(1, 'CRP measurement', 'PCR'),
(1, 'Cuba', 'Cuba'),
(1, 'Current smoking', 'Fumante'),
(1, 'Cylinder', 'Cilindro'),
(1, 'Cyprus', 'Cyprus'),
(1, 'Czech Republic', 'Czech Republic'),
(1, 'D-dimer measurement', 'Dimero D'),
(1, 'Daily clinical features', 'Sintomas diários'),
(1, 'Date of Birth', 'Data de nascimento'),
(1, 'Date of enrolment', 'Data de inscrição'),
(1, 'Date of follow up', 'Data do acompanhamento'),
(1, 'Date of ICU/HDU admission', 'Data de Admissão no CTI/UTI'),
(1, 'Date of onset and admission vital signs', 'Início da doença e sinais vitais na admissão'),
(1, 'Date question', 'Pergunta sobre data'),
(1, 'Death', 'Óbito'),
(1, 'Demographics', 'Dados demográficos'),
(1, 'Denmark', 'Denmark'),
(1, 'Diabetes', 'Diabete'),
(1, 'Diagnostic/pathogen testing', 'DIagnóstico/teste de patógenos'),
(1, 'Diarrhoea', 'Diarréia'),
(1, 'Discharge sub-section of the WHO COVID-19 CRF. This sub-section is provided when the patient is discharged from the health center or in the case of death.', 'Sub-seção de alta do FRC para o COVID-19 da OMS. Essa sub-seção é fornecida quando o paciente recebe alta do centro médica or em caso de óbito.'),
(1, 'Discharge/death form', 'Formulário de alta/óbito'),
(1, 'Discharged alive', 'Alta'),
(1, 'Djibouti', 'Djibouti'),
(1, 'Dominica', 'Dominica'),
(1, 'Dominican Republic', 'Dominican Republic'),
(1, 'duration in days', 'duração em dias'),
(1, 'duration in weeks', 'duração em semanas'),
(1, 'Dyspnoea (shortness of breath) OR Tachypnoea', 'Dispneia (falta de ar) ou Taquipneia'),
(1, 'e.g.BIPAP/CPAP', 'p.ex. BIPAP, CPAP'),
(1, 'Ecuador', 'Ecuador'),
(1, 'Egypt', 'Egypt'),
(1, 'El Salvador', 'El Salvador'),
(1, 'Endocarditis', 'Endocardite'),
(1, 'Equatorial Guinea', 'Equatorial Guinea'),
(1, 'Eritrea', 'Eritrea'),
(1, 'ESR measurement', 'VHS'),
(1, 'Estonia', 'Estonia'),
(1, 'Ethiopia', 'Ethiopia'),
(1, 'Existing conditions prior to admission.', 'Comorbidades existentes antes da admissão.'),
(1, 'Experimental agent', 'Agente experimental'),
(1, 'Extracorporeal (ECMO) support', 'Suporte extracorpóreo (ECMO)'),
(1, 'Facility name', 'Nome da Instalação'),
(1, 'Falciparum malaria', 'Malária Falciparum'),
(1, 'Falkland Islands (Malvinas)', 'Falkland Islands (Malvinas)'),
(1, 'Faroe Islands', 'Faroe Islands'),
(1, 'Fatigue/Malaise', 'Fadiga/mal estar'),
(1, 'Favipiravir', 'Favipiravir'),
(1, 'Female', 'Feminino'),
(1, 'Ferritin measurement', 'Ferritina'),
(1, 'Fiji', 'Fiji'),
(1, 'Finland', 'Finland'),
(1, 'FiO2 value', 'Fração de oxigênio inspirado'),
(1, 'first available data at presentation/admission', 'primeiros dados disponíveis na admissão'),
(1, 'Follow-up', 'Acompanhamento'),
(1, 'Follow-up sub-section of the WHO COVID-19 CRF. The completion frequency of this sub-section is determined by available resources.', 'Sub-seção do FRC para o COVID-19 da OMS. A frequência de preenchimento dessa sub-seção é determinada pelos recursos disponíveis.'),
(1, 'France', 'France'),
(1, 'French Guiana', 'French Guiana'),
(1, 'French Polynesia', 'French Polynesia'),
(1, 'French Southern Territories', 'French Southern Territories'),
(1, 'Gabon', 'Gabon'),
(1, 'Gambia', 'Gambia'),
(1, 'Georgia', 'Georgia'),
(1, 'Germany', 'Germany'),
(1, 'Gestational weeks assessment', 'Tempo de gravidez'),
(1, 'Ghana', 'Ghana'),
(1, 'Gibraltar', 'Gibraltar'),
(1, 'Glasgow Coma Score (GCS /15)', 'Escala de Coma de Glasgow (GCS /15)'),
(1, 'Greece', 'Greece'),
(1, 'Greenland', 'Greenland'),
(1, 'Grenada', 'Grenada'),
(1, 'Guadeloupe', 'Guadeloupe'),
(1, 'Guam', 'Guam'),
(1, 'Guatemala', 'Guatemala'),
(1, 'Guernsey', 'Guernsey'),
(1, 'Guinea', 'Guinea'),
(1, 'Guinea-Bissau', 'Guinea-Bissau'),
(1, 'Guyana', 'Guyana'),
(1, 'Haematocrit measurement', 'Hematócrito'),
(1, 'Haemoglobin measurement', 'Hemoglobina'),
(1, 'Haiti', 'Haiti'),
(1, 'Headache', 'Dor de cabeça'),
(1, 'Healthcare worker', 'Profissional de Saúde'),
(1, 'Heard Island and McDonald Islands', 'Heard Island and McDonald Islands'),
(1, 'Heart rate', 'Frequência cardíaca'),
(1, 'Height', 'Altura'),
(1, 'HF nasal cannula', 'Cânula nasal de alto fluxo'),
(1, 'History of fever', 'Histórico de febre'),
(1, 'HIV', 'HIV'),
(1, 'HIV list', 'Lista HIV'),
(1, 'Holy See (Vatican City State)', 'Holy See (Vatican City State)'),
(1, 'Honduras', 'Honduras'),
(1, 'Hong Kong', 'Hong Kong'),
(1, 'Hospitalized', 'Internado'),
(1, 'Hungary', 'Hungary'),
(1, 'Hypertension', 'Hipertensão'),
(1, 'Iceland', 'Iceland'),
(1, 'ICU or High Dependency Unit admission', 'UTI ou UCE'),
(1, 'ICU/HDU discharge date', 'Data de Alta do CTI/UTI'),
(1, 'If bleeding: specify site(s)', 'Caso afirmativo: especifique o(s) local(is)'),
(1, 'If yes, specify', 'Caso afirmativo, especifique'),
(1, 'IL-6 measurement', 'IL-6'),
(1, 'Inability to walk', 'Incapaz de andar'),
(1, 'India', 'India'),
(1, 'Indonesia', 'Indonesia'),
(1, 'Infiltrates present', 'Presença de infiltrados'),
(1, 'Influenza virus', 'Vírus influenza'),
(1, 'Influenza virus type', 'tipo de vírus influenza'),
(1, 'Inhaled', 'Inalatória'),
(1, 'Inotropes/vasopressors', 'Inotrópicos/vasopressores'),
(1, 'INR measurement', 'INR'),
(1, 'Interface list', 'Lista Interface de O2'),
(1, 'Interferon alpha', 'Interferon alfa'),
(1, 'Interferon beta', 'Interferon beta'),
(1, 'Intravenous', 'Intravenosa'),
(1, 'Intravenous fluids', 'Hidratação venosa'),
(1, 'Invasive ventilation', 'Ventilação invasiva'),
(1, 'Iran, Islamic Republic of', 'Iran, Islamic Republic of'),
(1, 'Iraq', 'Iraq'),
(1, 'Ireland', 'Ireland'),
(1, 'Is the patient CURRENTLY receiving any of the following?', 'O paciente esta recebendo algum dos seguintes ATUALMENTE?'),
(1, 'Isle of Man', 'Isle of Man'),
(1, 'Israel', 'Israel'),
(1, 'Italy', 'Italy'),
(1, 'Jamaica', 'Jamaica'),
(1, 'Japan', 'Japan'),
(1, 'Jersey', 'Jersey'),
(1, 'Joint pain (arthralgia)', 'Dor articular (artralgia)'),
(1, 'Jordan', 'Jordan'),
(1, 'Kazakhstan', 'Kazakhstan'),
(1, 'Kenya', 'Kenya'),
(1, 'Kiribati', 'Kiribati'),
(1, 'Korea, Democratic People\'s Republic of', 'Korea, Democratic People\'s Republic of'),
(1, 'Korea, Republic of', 'Korea, Republic of'),
(1, 'Kuwait', 'Kuwait'),
(1, 'Kyrgyzstan', 'Kyrgyzstan'),
(1, 'Laboratory question', 'Pergunta laboratorial'),
(1, 'Laboratory results', 'Resultados laboratoriais'),
(1, 'Laboratory Worker', 'Profissional de Laboratório'),
(1, 'Lactate measurement', 'Lactose'),
(1, 'Lao People\'s Democratic Republic', 'Lao People\'s Democratic Republic'),
(1, 'Latvia', 'Latvia'),
(1, 'LDH measurement', 'LDH'),
(1, 'Lebanon', 'Lebanon'),
(1, 'Lesotho', 'Lesotho'),
(1, 'Liberia', 'Liberia'),
(1, 'Libyan Arab Jamahiriya', 'Libyan Arab Jamahiriya'),
(1, 'Liechtenstein', 'Liechtenstein'),
(1, 'List of instances of the answers for the \'Sex at Birth\' question. In the WHO CRF, the three possible answers are: male, female or not specified.', 'Lista de instâncias das possíveis respostas para a pergunta \'Sexo as nascer\'. No FRC da OMS as três possíveis respostas são: masculino, feminino ou não especificado.'),
(1, 'List question', 'Questão com respostas em lista padronizada'),
(1, 'Lithuania', 'Lithuania'),
(1, 'Liver dysfunction', 'Disfunção hepática'),
(1, 'Lopinavir/Ritonavir', 'Lopinavir/Ritonavir'),
(1, 'Loss of smell', 'Perda do Olfato'),
(1, 'Loss of smell daily', 'Perda do Olfato'),
(1, 'Loss of smell signs', 'Perda do Olfato'),
(1, 'Loss of taste', 'Perda do paladar'),
(1, 'Loss of taste daily', 'Perda do paladar'),
(1, 'Loss of taste signs', 'Perda do paladar'),
(1, 'Lower chest wall indrawing', 'Retração toráxica'),
(1, 'Luxembourg', 'Luxembourg'),
(1, 'Lymphadenopathy', 'Linfadenopatia'),
(1, 'Macao', 'Macao'),
(1, 'Macedonia, the former Yugoslav Republic of', 'Macedonia, the former Yugoslav Republic of'),
(1, 'Madagascar', 'Madagascar'),
(1, 'Malawi', 'Malawi'),
(1, 'Malaysia', 'Malaysia'),
(1, 'Maldives', 'Maldives'),
(1, 'Male', 'Masculino'),
(1, 'Mali', 'Mali'),
(1, 'Malignant neoplasm', 'Neoplasma maligno'),
(1, 'Malnutrition', 'Desnutrição'),
(1, 'Malta', 'Malta'),
(1, 'Marshall Islands', 'Marshall Islands'),
(1, 'Martinique', 'Martinique'),
(1, 'Mask', 'Máscara'),
(1, 'Mask with reservoir', 'Máscara com reservatório'),
(1, 'Mauritania', 'Mauritania'),
(1, 'Mauritius', 'Mauritius'),
(1, 'Maximum daily corticosteroid dose', 'Dose diária máxima de corticosteroide'),
(1, 'Mayotte', 'Mayotte'),
(1, 'Medication', 'Medicação'),
(1, 'Meningitis/Encephalitis', 'Meningite/encefalite'),
(1, 'MERS-CoV', 'MERS-CoV'),
(1, 'Mexico', 'Mexico'),
(1, 'Micronesia, Federated States of', 'Micronesia, Federated States of'),
(1, 'Mid-upper arm circumference', 'Circunferência braquial'),
(1, 'Moldova, Republic of', 'Moldova, Republic of'),
(1, 'Monaco', 'Monaco'),
(1, 'Mongolia', 'Mongolia'),
(1, 'Montenegro', 'Montenegro'),
(1, 'Montserrat', 'Montserrat'),
(1, 'Morocco', 'Morocco'),
(1, 'Mozambique', 'Mozambique'),
(1, 'Muscle aches (myalgia)', 'Dor muscular (mialgia)'),
(1, 'Myanmar', 'Myanmar'),
(1, 'Myocarditis/Pericarditis', 'Miocardite/Pericardite'),
(1, 'N/A', 'Não informado'),
(1, 'Namibia', 'Namibia'),
(1, 'Nauru', 'Nauru'),
(1, 'Negative', 'Negativo'),
(1, 'Nepal', 'Nepal'),
(1, 'Netherlands', 'Netherlands'),
(1, 'Netherlands Antilles', 'Netherlands Antilles'),
(1, 'Neuraminidase inhibitor', 'Inibidor de neuraminidase'),
(1, 'New Caledonia', 'New Caledonia'),
(1, 'New Zealand', 'New Zealand'),
(1, 'Nicaragua', 'Nicaragua'),
(1, 'Niger', 'Niger'),
(1, 'Nigeria', 'Nigeria'),
(1, 'Niue', 'Niue'),
(1, 'No', 'Não'),
(1, 'Non-Falciparum malaria', 'Malária Não Falciparum'),
(1, 'Non-invasive ventilation', 'Ventilação não-invasiva'),
(1, 'Non-steroidal anti-inflammatory (NSAID)', 'Antiinflamatório não esteroide (AINE)'),
(1, 'Norfolk Island', 'Norfolk Island'),
(1, 'Northern Mariana Islands', 'Northern Mariana Islands'),
(1, 'Norway', 'Norway'),
(1, 'Not done', 'Não realizado'),
(1, 'Not known, not observed, not recorded, or refused.', 'Desconhecido, não observado, não registrato or recusado.'),
(1, 'Not Specified', 'Não especificado'),
(1, 'Number question', 'Pergunta numérica'),
(1, 'O2 flow', 'Vazão de O2'),
(1, 'O2 flow list', 'Lista fluxo de O2'),
(1, 'Oman', 'Oman'),
(1, 'Oral', 'Oral'),
(1, 'Oral/orogastric fluids', 'Hidratação oral/orogástrica'),
(1, 'Other co-morbidities', 'Outras comorbidades'),
(1, 'Other complication', 'Outra complicação'),
(1, 'Other corona virus', 'Outro coronavírus'),
(1, 'Other respiratory pathogen', 'Outro patógeno respiratório'),
(1, 'Other signs or symptoms', 'Outros'),
(1, 'Outcome', 'Desfecho'),
(1, 'Outcome date', 'Data do desfecho'),
(1, 'Outcome list', 'Lista de desfecho'),
(1, 'Outcome saturation list', 'Lista de Saturação de desfecho'),
(1, 'Oxygen interface', 'Interface de oxigenoterapia'),
(1, 'Oxygen saturation', 'Saturação de oxigênio'),
(1, 'Oxygen saturation expl', 'em'),
(1, 'Oxygen therapy', 'Oxigenoterapia'),
(1, 'PaCO2 value', 'Pressão parcial do CO2'),
(1, 'Pain', 'Dor'),
(1, 'Pakistan', 'Pakistan'),
(1, 'Palau', 'Palau'),
(1, 'Palestinian Territory, Occupied', 'Palestinian Territory, Occupied'),
(1, 'Palliative discharge', 'Alta paliativa'),
(1, 'Panama', 'Panama'),
(1, 'Pancreatitis', 'Pancreatite'),
(1, 'PaO2 value', 'Pressão parcial do O2'),
(1, 'Papua New Guinea', 'Papua New Guinea'),
(1, 'Paraguay', 'Paraguay'),
(1, 'PEEP value', 'Pressão expiratória final positiva'),
(1, 'Peru', 'Peru'),
(1, 'Philippines', 'Philippines'),
(1, 'Piped', 'Canalizado'),
(1, 'Pitcairn', 'Pitcairn'),
(1, 'Plateau pressure value', 'Pressão do plato'),
(1, 'Platelets measurement', 'Plaquetas'),
(1, 'Pneumonia', 'Pneumonia'),
(1, 'PNNot_done_Question', 'Questão com resposta Positivo Negativo ou não realizada'),
(1, 'pnnotdone_list', 'Lista PNNotDone'),
(1, 'Poland', 'Poland'),
(1, 'Portugal', 'Portugal'),
(1, 'Positive', 'Positivo'),
(1, 'Potassium measurement', 'Potássio'),
(1, 'Pre-admission & chronic medication', 'Pré-admissão e medicamentos de uso contínuo'),
(1, 'Pregnant', 'Grávida'),
(1, 'Procalcitonin measurement', 'Procalcitonina'),
(1, 'Prone position', 'Posição prona'),
(1, 'Proven or suspected infection with pathogen of Public Health Interest', 'Quadro de infecção comprovada ou suspeita com patógeno de interesse para a Saúde Pública'),
(1, 'PT measurement', 'TP'),
(1, 'Puerto Rico', 'Puerto Rico'),
(1, 'Qatar', 'Qatar'),
(1, 'Renal replacement therapy (RRT) or dialysis', 'Terapia de substituição renal ou diálise'),
(1, 'Respiratory rate', 'Frequência respiratória'),
(1, 'Reunion ﻿ Réunion', 'Reunion ﻿ Réunion'),
(1, 'Ribavirin', 'Ribavirina'),
(1, 'Romania', 'Romania'),
(1, 'Room air', 'ar ambiente'),
(1, 'Runny nose (rhinorrhoea)', 'Coriza (rinorréia)'),
(1, 'Russian Federation', 'Russian Federation'),
(1, 'Rwanda', 'Rwanda'),
(1, 'Saint Barthélemy', 'Saint Barthélemy'),
(1, 'Saint Helena', 'Saint Helena'),
(1, 'Saint Kitts and Nevis', 'Saint Kitts and Nevis'),
(1, 'Saint Lucia', 'Saint Lucia'),
(1, 'Saint Martin (French part)', 'Saint Martin (French part)'),
(1, 'Saint Pierre and Miquelon', 'Saint Pierre and Miquelon'),
(1, 'Saint Vincent and the Grenadines', 'Saint Vincent and the Grenadines'),
(1, 'Same as before illness', 'Como antes da doença'),
(1, 'Samoa', 'Samoa'),
(1, 'San Marino', 'San Marino'),
(1, 'Sao Tome and Principe', 'Sao Tome and Principe'),
(1, 'SARS-CoV-2', 'SARS-CoV-2'),
(1, 'Saudi Arabia', 'Saudi Arabia'),
(1, 'Seizures', 'Convulsões'),
(1, 'self_care_list', 'Lista cuidados'),
(1, 'Senegal', 'Senegal'),
(1, 'Serbia', 'Serbia'),
(1, 'Severe dehydration', 'Desidratação severa'),
(1, 'Sex at Birth', 'Sexo ao Nascer'),
(1, 'sex at birth list', 'Lista de sexo'),
(1, 'Seychelles', 'Seychelles'),
(1, 'Shock', 'Choque'),
(1, 'Shortness of breath', 'Falta de ar'),
(1, 'Sierra Leone', 'Sierra Leone'),
(1, 'Signs and symptoms on admission', 'Sinais e sintomas na hora da admissão'),
(1, 'Singapore', 'Singapore'),
(1, 'Site name', 'Localidade'),
(1, 'Skin rash', 'Erupções cutâneas'),
(1, 'Skin ulcers', 'Úlceras cutâneas'),
(1, 'Slovakia', 'Slovakia'),
(1, 'Slovenia', 'Slovenia'),
(1, 'Sodium measurement', 'Sódio'),
(1, 'Solomon Islands', 'Solomon Islands'),
(1, 'Somalia', 'Somalia'),
(1, 'Sore throat', 'Dor de garganta'),
(1, 'Source of oxygen', 'Fonte de Oxigênio'),
(1, 'Source of oxygen list', 'lista de fonte de O2'),
(1, 'South Africa', 'South Africa'),
(1, 'South Georgia and the South Sandwich Islands', 'South Georgia and the South Sandwich Islands'),
(1, 'Spain', 'Spain'),
(1, 'specific response', 'resposta específica'),
(1, 'Sri Lanka', 'Sri Lanka'),
(1, 'Sternal capillary refill time >2seconds', 'Tempo de enchimento capilar >2 segundos'),
(1, 'Sudan', 'Sudan'),
(1, 'Supportive care', 'Cuidados'),
(1, 'Suriname', 'Suriname'),
(1, 'Svalbard and Jan Mayen', 'Svalbard and Jan Mayen'),
(1, 'Swaziland', 'Swaziland'),
(1, 'Sweden', 'Sweden'),
(1, 'Switzerland', 'Switzerland'),
(1, 'Symptom onset (date of first/earliest symptom)', 'Início de Sintomas (data do primeiro sintoma)'),
(1, 'Syrian Arab Republic', 'Syrian Arab Republic'),
(1, 'Systemic anticoagulation', 'Anticoagulação sistêmica'),
(1, 'Taiwan, Province of China', 'Taiwan, Province of China'),
(1, 'Tajikistan', 'Tajikistan'),
(1, 'Tanzania, United Republic of', 'Tanzania, United Republic of'),
(1, 'Temperature', 'Temperatura'),
(1, 'Text_Question', 'Questão com resposta textual'),
(1, 'Thailand', 'Thailand'),
(1, 'The affirmative response to a question.', 'A resposta afirmativa à uma pergunta.'),
(1, 'The country where the medical center is located.', 'O país onde o centro médico está localizado.'),
(1, 'The name of the health center in which the participant is being treated.', 'O centro médico onde o participante está sendo tratado.'),
(1, 'The non-affirmative response to a question.', 'A resposta negativa à uma pergunta.'),
(1, 'The number of breaths (inhalation and exhalation) taken per minute time.', 'O número de respirações medidos a cada minuto.'),
(1, 'The number of heartbeats measured per minute time.', 'O número de batimentos cardíacos medidos a cada minuto.'),
(1, 'The Person that is the case subject of the WHO CRF.', 'A Pessoa que é o objeto do caso relatado pelo FRC da OMS.'),
(1, 'This class represents the Rapid version of the World Health Organisation\'s (WHO) Case Record Form (CRF) for the COVID-19 outbreak.', 'Esta classe representa a versão Rapid do Formulário de Relato de Caso (FRC) para a epidemia COVID-19, criada pela Organização Mundial de Saúde.'),
(1, 'time in weeks', 'tempo em semanas'),
(1, 'Timor-Leste', 'Timor-Leste'),
(1, 'Togo', 'Togo'),
(1, 'Tokelau', 'Tokelau'),
(1, 'Tonga', 'Tonga'),
(1, 'Total bilirubin measurement', 'Bilirrubina total'),
(1, 'Total duration ECMO', 'duração em dias'),
(1, 'Total duration ICU/HCU', 'duração em dias'),
(1, 'Total duration Inotropes/vasopressors', 'duração em dias'),
(1, 'Total duration Invasive ventilation', 'duração em dias'),
(1, 'Total duration Non-invasive ventilation', 'duração em dias'),
(1, 'Total duration Oxygen Therapy', 'duração em dias'),
(1, 'Total duration Prone position', 'duração em dias'),
(1, 'Total duration RRT or dyalysis', 'duração em dias'),
(1, 'Transfer to other facility', 'Transferência para outra unidade'),
(1, 'Trinidad and Tobago', 'Trinidad and Tobago'),
(1, 'Troponin measurement', 'Troponina'),
(1, 'Tuberculosis', 'Tuberculose'),
(1, 'Tunisia', 'Tunisia'),
(1, 'Turkey', 'Turkey'),
(1, 'Turkmenistan', 'Turkmenistan'),
(1, 'Turks and Caicos Islands', 'Turks and Caicos Islands'),
(1, 'Tuvalu', 'Tuvalu'),
(1, 'Uganda', 'Uganda'),
(1, 'Ukraine', 'Ukraine'),
(1, 'United Arab Emirates', 'United Arab Emirates'),
(1, 'United Kingdom', 'United Kingdom'),
(1, 'United States', 'United States'),
(1, 'United States Minor Outlying Islands', 'United States Minor Outlying Islands'),
(1, 'Unknown', 'Desconhecido'),
(1, 'Unresponsive', 'Indiferente'),
(1, 'Urea (BUN) measurement', 'Uréia (BUN)'),
(1, 'Uruguay', 'Uruguay'),
(1, 'Uzbekistan', 'Uzbekistan'),
(1, 'Vanuatu', 'Vanuatu'),
(1, 'Venezuela, Bolivarian Republic of', 'Venezuela, Bolivarian Republic of'),
(1, 'Ventilation question', 'Questão sobre Ventilação'),
(1, 'Verbal', 'Verbal'),
(1, 'Viet Nam', 'Viet Nam'),
(1, 'Viral haemorrhagic fever', 'Febre viral hemorrágica'),
(1, 'Virgin Islands, British', 'Virgin Islands, British'),
(1, 'Virgin Islands, U.S.', 'Virgin Islands, U.S.'),
(1, 'Vital signs', 'Sinais Vitais'),
(1, 'Vomiting/Nausea', 'Vômito/náusea'),
(1, 'Wallis and Futuna', 'Wallis and Futuna'),
(1, 'Was pathogen testing done during this illness episode', 'Esse teste foi realizado durante este episódio da doença'),
(1, 'WBC count measurement', 'Leucócitos'),
(1, 'Weight', 'Peso'),
(1, 'Were any of the following taken within 14 days of admission?', 'Marque os usados nos 14 dias antes da admissão'),
(1, 'Western Sahara', 'Western Sahara'),
(1, 'Wheezing', 'Respiração sibilante'),
(1, 'Which antibiotic', 'Antibiótico'),
(1, 'Which antifungal agent', 'Qual agente antifungal'),
(1, 'Which antimalarial agent', 'Qual agente antimalárico'),
(1, 'Which antiviral', 'Qual antiviral'),
(1, 'Which complication', 'Qual complicação'),
(1, 'Which coronavirus', 'Qual coronavírus'),
(1, 'Which corticosteroid route', 'Qual via do corticosteroide'),
(1, 'Which experimental agent', 'Qual agente experimental'),
(1, 'Which NSAID', 'Qual AINE'),
(1, 'Which other antiviral', 'Qual outro antiviral'),
(1, 'Which other co-morbidities', 'Outras comorbidades'),
(1, 'Which other pathogen of public health interest detected', 'Qual outro patógeno'),
(1, 'Which respiratory pathogen', 'Qual patógeno respiratório'),
(1, 'Which sign or symptom', 'Qual sinal ou sintoma'),
(1, 'Which virus', 'Qual vírus'),
(1, 'WHO COVID-19 Rapid Version CRF', 'OMS-COVID-19-Rapid-FRC'),
(1, 'Worse', 'Pior'),
(1, 'Yemen', 'Yemen'),
(1, 'Yes', 'Sim'),
(1, 'Yes-not on ART', 'Sim-não toma antivirais'),
(1, 'Yes-on ART', 'Sim-toma antivirais'),
(1, 'ynu_list', 'Lista YNU'),
(1, 'YNU_Question', 'Questão com resposta Sim Não Desconhecido'),
(1, 'ynun_list', 'Lista YNUN'),
(1, 'YNUN_Question', 'Questão com resposta Sim Não Desconhecido Não Informado'),
(1, 'Zambia', 'Zambia'),
(1, 'Zimbabwe', 'Zimbabwe');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_notificationrecord`
--

DROP TABLE IF EXISTS `tb_notificationrecord`;
CREATE TABLE `tb_notificationrecord` (
  `userID` int(11) NOT NULL,
  `profileID` int(11) NOT NULL,
  `hospitalUnitID` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `rowdID` int(11) NOT NULL,
  `changedOn` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `operation` varchar(1) NOT NULL,
  `log` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_notificationrecord`
--

TRUNCATE TABLE `tb_notificationrecord`;
-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_participant`
--

DROP TABLE IF EXISTS `tb_participant`;
CREATE TABLE `tb_participant` (
  `participantID` int(10) NOT NULL,
  `medicalRecord` varchar(500) DEFAULT NULL COMMENT '(pt-br) prontuário do paciente. \r\n(en) patient medical record.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='(pt-br) Tabela para registros de pacientes.\r\n(en) Table for patient records.';

--
-- Tabela truncada antes do insert `tb_participant`
--

TRUNCATE TABLE `tb_participant`;
--
-- Despejando dados para a tabela `tb_participant`
--

INSERT INTO `tb_participant` (`participantID`, `medicalRecord`) VALUES
(1, '50135'),
(2, '53105');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_permission`
--

DROP TABLE IF EXISTS `tb_permission`;
CREATE TABLE `tb_permission` (
  `permissionID` bigint(20) UNSIGNED NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_permission`
--

TRUNCATE TABLE `tb_permission`;
--
-- Despejando dados para a tabela `tb_permission`
--

INSERT INTO `tb_permission` (`permissionID`, `description`) VALUES
(1, 'Insert'),
(2, 'Update'),
(3, 'Delete'),
(4, 'ALL');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questiongroup`
--

DROP TABLE IF EXISTS `tb_questiongroup`;
CREATE TABLE `tb_questiongroup` (
  `questionGroupID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição.\r\n(en) description.',
  `comment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Relacionado ao Question Group da ontologia relaciona as diversas sessoes existentes nos formularios do CRF COVID-19';

--
-- Tabela truncada antes do insert `tb_questiongroup`
--

TRUNCATE TABLE `tb_questiongroup`;
--
-- Despejando dados para a tabela `tb_questiongroup`
--

INSERT INTO `tb_questiongroup` (`questionGroupID`, `description`, `comment`) VALUES
(1, 'Clinical inclusion criteria', ''),
(2, 'Co-morbidities', 'Existing conditions prior to admission.'),
(3, 'Complications', ''),
(4, 'Daily clinical features', ''),
(5, 'Date of onset and admission vital signs', 'first available data at presentation/admission'),
(6, 'Demographics', ''),
(7, 'Diagnostic/pathogen testing', ''),
(8, 'Laboratory results', ''),
(9, 'Medication', 'Is the patient CURRENTLY receiving any of the following?'),
(10, 'Outcome', ''),
(11, 'Pre-admission & chronic medication', 'Were any of the following taken within 14 days of admission?'),
(12, 'Signs and symptoms on admission', ''),
(13, 'Supportive care', 'Is the patient CURRENTLY receiving any of the following?'),
(14, 'Vital signs', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questiongroupform`
--

DROP TABLE IF EXISTS `tb_questiongroupform`;
CREATE TABLE `tb_questiongroupform` (
  `crfFormsID` int(10) NOT NULL,
  `questionID` int(10) NOT NULL,
  `questionOrder` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_questiongroupform`
--

TRUNCATE TABLE `tb_questiongroupform`;
--
-- Despejando dados para a tabela `tb_questiongroupform`
--

INSERT INTO `tb_questiongroupform` (`crfFormsID`, `questionID`, `questionOrder`) VALUES
(1, 29, 10629),
(1, 33, 10710),
(1, 34, 10711),
(1, 35, 10703),
(1, 36, 10706),
(1, 37, 10713),
(1, 38, 10627),
(1, 39, 10802),
(1, 40, 10310),
(1, 47, 10102),
(1, 48, 10105),
(1, 49, 10101),
(1, 50, 10404),
(1, 51, 10412),
(1, 52, 10401),
(1, 53, 10405),
(1, 54, 10406),
(1, 55, 10407),
(1, 56, 10403),
(1, 57, 10410),
(1, 58, 10409),
(1, 59, 10408),
(1, 60, 10402),
(1, 61, 10413),
(1, 62, 10414),
(1, 63, 10104),
(1, 64, 10103),
(1, 65, 10411),
(1, 82, 10707),
(1, 87, 10708),
(1, 89, 10803),
(1, 90, 10805),
(1, 91, 10628),
(1, 92, 10804),
(1, 93, 10302),
(1, 94, 10316),
(1, 95, 10314),
(1, 96, 10315),
(1, 97, 10301),
(1, 98, 10317),
(1, 100, 10712),
(1, 101, 10704),
(1, 103, 10714),
(1, 104, 10705),
(1, 107, 10202),
(1, 108, 10205),
(1, 109, 10206),
(1, 110, 10207),
(1, 111, 10201),
(1, 113, 10208),
(1, 114, 10908),
(1, 115, 10905),
(1, 116, 10910),
(1, 117, 10709),
(1, 118, 10921),
(1, 119, 10702),
(1, 120, 10701),
(1, 127, 10619),
(1, 128, 10604),
(1, 129, 10611),
(1, 130, 10616),
(1, 132, 10601),
(1, 133, 10626),
(1, 134, 10610),
(1, 135, 10615),
(1, 136, 10625),
(1, 137, 10606),
(1, 138, 10623),
(1, 139, 10624),
(1, 140, 10607),
(1, 141, 10311),
(1, 143, 10630),
(1, 144, 10204),
(1, 145, 10919),
(1, 146, 10913),
(1, 147, 10917),
(1, 148, 10922),
(1, 149, 10815),
(1, 150, 10801),
(1, 151, 10814),
(1, 152, 10808),
(1, 153, 10806),
(1, 154, 10807),
(1, 155, 10816),
(1, 156, 10923),
(1, 157, 10903),
(1, 158, 10901),
(1, 159, 10924),
(1, 160, 10907),
(1, 161, 10912),
(1, 162, 10918),
(1, 163, 10904),
(1, 164, 10915),
(1, 165, 10916),
(1, 166, 10003),
(1, 167, 10004),
(1, 169, 10906),
(1, 170, 10914),
(1, 171, 10909),
(1, 172, 10920),
(1, 174, 10911),
(1, 189, 10308),
(1, 190, 10312),
(1, 191, 10304),
(1, 192, 10307),
(1, 193, 10313),
(1, 194, 10305),
(1, 195, 10306),
(1, 196, 10309),
(1, 198, 10303),
(1, 199, 10715),
(1, 200, 10716),
(1, 201, 10717),
(1, 202, 10501),
(1, 203, 10502),
(1, 204, 10503),
(1, 205, 10614),
(1, 206, 10620),
(1, 207, 10617),
(1, 208, 10621),
(1, 209, 10609),
(1, 210, 10602),
(1, 211, 10618),
(1, 212, 10203),
(1, 213, 10622),
(1, 214, 10608),
(1, 215, 10605),
(1, 225, 10603),
(1, 226, 10902),
(1, 227, 10415),
(1, 241, 10718),
(1, 242, 10002),
(1, 245, 10810),
(1, 246, 10813),
(1, 247, 10812),
(1, 248, 10811),
(1, 249, 10809),
(1, 252, 10613),
(1, 253, 10612),
(1, 254, 10504),
(1, 255, 10505),
(2, 28, 20214),
(2, 33, 20410),
(2, 34, 20411),
(2, 35, 20403),
(2, 36, 20406),
(2, 37, 20413),
(2, 39, 20504),
(2, 41, 20109),
(2, 82, 20407),
(2, 83, 20208),
(2, 87, 20408),
(2, 89, 20505),
(2, 90, 20507),
(2, 92, 20506),
(2, 100, 20412),
(2, 101, 20404),
(2, 103, 20414),
(2, 104, 20405),
(2, 112, 20110),
(2, 114, 20308),
(2, 115, 20305),
(2, 116, 20310),
(2, 117, 20409),
(2, 118, 20321),
(2, 119, 20402),
(2, 120, 20401),
(2, 142, 20215),
(2, 145, 20319),
(2, 146, 20313),
(2, 147, 20317),
(2, 148, 20322),
(2, 149, 20516),
(2, 150, 20501),
(2, 151, 20517),
(2, 152, 20510),
(2, 153, 20508),
(2, 154, 20509),
(2, 155, 20518),
(2, 156, 20323),
(2, 157, 20303),
(2, 158, 20301),
(2, 159, 20324),
(2, 160, 20307),
(2, 161, 20312),
(2, 162, 20318),
(2, 163, 20304),
(2, 164, 20315),
(2, 165, 20316),
(2, 168, 20002),
(2, 169, 20306),
(2, 170, 20314),
(2, 171, 20309),
(2, 172, 20320),
(2, 174, 20311),
(2, 177, 20204),
(2, 178, 20209),
(2, 182, 20210),
(2, 183, 20201),
(2, 184, 20203),
(2, 185, 20205),
(2, 186, 20211),
(2, 187, 20213),
(2, 188, 20212),
(2, 197, 20202),
(2, 199, 20415),
(2, 200, 20416),
(2, 201, 20417),
(2, 216, 20111),
(2, 217, 20101),
(2, 218, 20107),
(2, 219, 20105),
(2, 220, 20106),
(2, 221, 20102),
(2, 222, 20104),
(2, 223, 20108),
(2, 224, 20103),
(2, 226, 20302),
(2, 228, 20502),
(2, 229, 20503),
(2, 241, 20418),
(2, 245, 20512),
(2, 246, 20515),
(2, 247, 20514),
(2, 248, 20513),
(2, 249, 20511),
(2, 250, 20206),
(2, 251, 20207),
(3, 30, 30218),
(3, 31, 30101),
(3, 32, 30103),
(3, 33, 30311),
(3, 34, 30313),
(3, 35, 30303),
(3, 36, 30308),
(3, 37, 30315),
(3, 39, 30404),
(3, 42, 30109),
(3, 43, 30111),
(3, 44, 30106),
(3, 45, 30107),
(3, 46, 30104),
(3, 66, 30214),
(3, 67, 30209),
(3, 68, 30204),
(3, 69, 30210),
(3, 70, 30211),
(3, 71, 30208),
(3, 72, 30206),
(3, 73, 30205),
(3, 74, 30217),
(3, 75, 30212),
(3, 76, 30216),
(3, 77, 30203),
(3, 78, 30213),
(3, 79, 30215),
(3, 80, 30207),
(3, 81, 30201),
(3, 82, 30309),
(3, 84, 30114),
(3, 85, 30116),
(3, 86, 30102),
(3, 87, 30310),
(3, 88, 30115),
(3, 89, 30406),
(3, 90, 30408),
(3, 92, 30407),
(3, 99, 30312),
(3, 100, 30314),
(3, 101, 30304),
(3, 102, 30219),
(3, 103, 30316),
(3, 104, 30305),
(3, 105, 30113),
(3, 106, 30108),
(3, 117, 30306),
(3, 119, 30302),
(3, 120, 30301),
(3, 121, 30105),
(3, 122, 30503),
(3, 123, 30501),
(3, 124, 30502),
(3, 125, 30110),
(3, 126, 30112),
(3, 149, 30413),
(3, 150, 30401),
(3, 151, 30418),
(3, 152, 30411),
(3, 153, 30409),
(3, 154, 30415),
(3, 155, 30417),
(3, 176, 30202),
(3, 180, 30318),
(3, 199, 30317),
(3, 228, 30403),
(3, 232, 30307),
(3, 233, 30402),
(3, 234, 30405),
(3, 235, 30410),
(3, 236, 30412),
(3, 237, 30414),
(3, 238, 30416),
(3, 240, 30419);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questiongroupformrecord`
--

DROP TABLE IF EXISTS `tb_questiongroupformrecord`;
CREATE TABLE `tb_questiongroupformrecord` (
  `questionGroupFormRecordID` int(10) NOT NULL,
  `formRecordID` int(10) NOT NULL,
  `crfFormsID` int(10) NOT NULL,
  `questionID` int(10) NOT NULL,
  `listOfValuesID` int(10) DEFAULT NULL,
  `answer` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='(pt-br) Tabela para registro da resposta associada a uma questão de um agrupamento de um formulário referente a um questionario de avaliação.\r\n(en) Form record table.';

--
-- Tabela truncada antes do insert `tb_questiongroupformrecord`
--

TRUNCATE TABLE `tb_questiongroupformrecord`;
-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questionnaire`
--

DROP TABLE IF EXISTS `tb_questionnaire`;
CREATE TABLE `tb_questionnaire` (
  `questionnaireID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_questionnaire`
--

TRUNCATE TABLE `tb_questionnaire`;
--
-- Despejando dados para a tabela `tb_questionnaire`
--

INSERT INTO `tb_questionnaire` (`questionnaireID`, `description`) VALUES
(1, 'WHO COVID-19 Rapid Version CRF');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questions`
--

DROP TABLE IF EXISTS `tb_questions`;
CREATE TABLE `tb_questions` (
  `questionID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição.\r\n(en) description.',
  `questionTypeID` int(10) NOT NULL COMMENT '(pt-br) Chave estrangeira para tabela tb_QuestionsTypes.\r\n(en) Foreign key for the tp_QuestionsTypes table.',
  `listTypeID` int(10) DEFAULT NULL,
  `questionGroupID` int(10) DEFAULT NULL,
  `subordinateTo` int(10) DEFAULT NULL,
  `isAbout` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_questions`
--

TRUNCATE TABLE `tb_questions`;
--
-- Despejando dados para a tabela `tb_questions`
--

INSERT INTO `tb_questions` (`questionID`, `description`, `questionTypeID`, `listTypeID`, `questionGroupID`, `subordinateTo`, `isAbout`) VALUES
(1, 'Age', 5, NULL, 6, NULL, NULL),
(2, 'Altered consciousness/confusion', 8, 15, NULL, NULL, NULL),
(3, 'Angiotensin converting enzyme inhibitors (ACE inhibitors)', 8, 15, NULL, NULL, NULL),
(4, 'Angiotensin II receptor blockers (ARBs)', 8, 15, NULL, NULL, NULL),
(5, 'AVPU scale', 4, 2, NULL, NULL, NULL),
(6, 'BP (diastolic)', 5, NULL, NULL, NULL, NULL),
(7, 'BP (systolic)', 5, NULL, NULL, NULL, NULL),
(8, 'Chest pain', 8, 15, NULL, NULL, NULL),
(9, 'Conjunctivitis', 8, 15, NULL, NULL, NULL),
(10, 'Cough', 8, 15, NULL, NULL, NULL),
(11, 'Cough with sputum', 8, 15, NULL, NULL, NULL),
(12, 'Diarrhoea', 8, 15, NULL, NULL, NULL),
(13, 'Glasgow Coma Score (GCS /15)', 5, NULL, NULL, NULL, NULL),
(14, 'Heart rate', 5, NULL, NULL, NULL, NULL),
(15, 'Muscle aches (myalgia)', 8, 15, NULL, NULL, NULL),
(16, 'Non-steroidal anti-inflammatory (NSAID)', 8, 15, NULL, NULL, NULL),
(17, 'Other signs or symptoms', 8, 15, NULL, NULL, NULL),
(18, 'Oxygen saturation', 5, NULL, NULL, NULL, NULL),
(19, 'Respiratory rate', 5, NULL, NULL, NULL, NULL),
(20, 'Seizures', 8, 15, NULL, NULL, NULL),
(21, 'Severe dehydration', 8, 15, NULL, NULL, NULL),
(22, 'Shortness of breath', 8, 15, NULL, NULL, NULL),
(23, 'Sore throat', 8, 15, NULL, NULL, NULL),
(24, 'Sternal capillary refill time >2seconds', 8, 15, NULL, NULL, NULL),
(25, 'Temperature', 5, NULL, NULL, NULL, NULL),
(26, 'Vomiting/Nausea', 8, 15, NULL, NULL, NULL),
(27, 'Which sign or symptom', 7, NULL, NULL, NULL, NULL),
(28, 'Other signs or symptoms', 8, 15, 4, NULL, 17),
(29, 'Other signs or symptoms', 8, 15, 12, NULL, 17),
(30, 'Other complication', 8, 15, 3, NULL, NULL),
(31, 'Chest X-Ray /CT performed', 8, 15, 7, NULL, NULL),
(32, 'Was pathogen testing done during this illness episode', 8, 15, 7, NULL, NULL),
(33, 'Antifungal agent', 8, 15, 9, NULL, NULL),
(34, 'Antimalarial agent', 8, 15, 9, NULL, NULL),
(35, 'Antiviral', 8, 15, 9, NULL, NULL),
(36, 'Corticosteroid', 8, 15, 9, NULL, NULL),
(37, 'Experimental agent', 8, 15, 9, NULL, NULL),
(38, 'Bleeding (Haemorrhage)', 8, 15, 12, NULL, NULL),
(39, 'Oxygen therapy', 8, 15, 13, NULL, NULL),
(40, 'Oxygen saturation', 5, NULL, 5, NULL, 18),
(41, 'Oxygen saturation', 5, NULL, 14, NULL, 18),
(42, 'Other respiratory pathogen', 6, 11, 7, 32, NULL),
(43, 'Viral haemorrhagic fever', 6, 11, 7, 32, NULL),
(44, 'Coronavirus', 6, 11, 7, 32, NULL),
(45, 'Which coronavirus', 4, 3, 7, 44, NULL),
(46, 'Influenza virus', 6, 11, 7, 32, NULL),
(47, 'A history of self-reported feverishness or measured fever of ≥ 38 degrees Celsius', 1, NULL, 1, NULL, NULL),
(48, 'Clinical suspicion of ARI despite not meeting criteria above', 1, NULL, 1, NULL, NULL),
(49, 'Proven or suspected infection with pathogen of Public Health Interest', 1, NULL, 1, NULL, NULL),
(50, 'Ashtma', 8, 15, 2, NULL, NULL),
(51, 'Asplenia', 8, 15, 2, NULL, NULL),
(52, 'Chronic cardiac disease (not hypertension)', 8, 15, 2, NULL, NULL),
(53, 'Chronic kidney disease', 8, 15, 2, NULL, NULL),
(54, 'Chronic liver disease', 8, 15, 2, NULL, NULL),
(55, 'Chronic neurological disorder', 8, 15, 2, NULL, NULL),
(56, 'Chronic pulmonary disease', 8, 15, 2, NULL, NULL),
(57, 'Current smoking', 8, 15, 2, NULL, NULL),
(58, 'Diabetes', 8, 15, 2, NULL, NULL),
(59, 'HIV', 4, 6, 2, NULL, NULL),
(60, 'Hypertension', 8, 15, 2, NULL, NULL),
(61, 'Malignant neoplasm', 8, 15, 2, NULL, NULL),
(62, 'Other co-morbidities', 8, 15, 2, NULL, NULL),
(63, 'Dyspnoea (shortness of breath) OR Tachypnoea', 1, NULL, 1, NULL, NULL),
(64, 'Cough', 1, NULL, 1, NULL, NULL),
(65, 'Tuberculosis', 8, 15, 2, NULL, NULL),
(66, 'Acute renal injury', 8, 15, 3, NULL, NULL),
(67, 'Acute Respiratory Distress Syndrome', 8, 15, 3, NULL, NULL),
(68, 'Anaemia', 8, 15, 3, NULL, NULL),
(69, 'Bacteraemia', 8, 15, 3, NULL, NULL),
(70, 'Bleeding', 8, 15, 3, NULL, NULL),
(71, 'Bronchiolitis', 8, 15, 3, NULL, NULL),
(72, 'Cardiac arrest', 8, 15, 3, NULL, NULL),
(73, 'Cardiac arrhythmia', 8, 15, 3, NULL, NULL),
(74, 'Cardiomyopathy', 8, 15, 3, NULL, NULL),
(75, 'Endocarditis', 8, 15, 3, NULL, NULL),
(76, 'Liver dysfunction', 8, 15, 3, NULL, NULL),
(77, 'Meningitis/Encephalitis', 8, 15, 3, NULL, NULL),
(78, 'Myocarditis/Pericarditis', 8, 15, 3, NULL, NULL),
(79, 'Pancreatitis', 8, 15, 3, NULL, NULL),
(80, 'Pneumonia', 8, 15, 3, NULL, NULL),
(81, 'Shock', 8, 15, 3, NULL, NULL),
(82, 'Which corticosteroid route', 4, 4, 9, 36, NULL),
(83, 'Confusion', 8, 15, 4, NULL, NULL),
(84, 'Falciparum malaria', 6, 11, 7, 32, NULL),
(85, 'HIV', 6, 11, 7, 32, NULL),
(86, 'Infiltrates present', 8, 15, 7, 31, NULL),
(87, 'Maximum daily corticosteroid dose', 7, NULL, 9, 36, NULL),
(88, 'Non-Falciparum malaria', 6, 11, 7, 32, NULL),
(89, 'O2 flow', 4, 8, 13, 39, NULL),
(90, 'Oxygen interface', 4, 7, 13, 39, NULL),
(91, 'Site name', 7, NULL, 12, 38, NULL),
(92, 'Source of oxygen', 4, 14, 13, 39, NULL),
(93, 'Admission date at this facility', 2, NULL, 5, NULL, NULL),
(94, 'Height', 5, NULL, 5, NULL, NULL),
(95, 'Malnutrition', 8, 15, 5, NULL, NULL),
(96, 'Mid-upper arm circumference', 5, NULL, 5, NULL, NULL),
(97, 'Symptom onset (date of first/earliest symptom)', 2, NULL, 5, NULL, NULL),
(98, 'Weight', 5, NULL, 5, NULL, NULL),
(99, 'Which antifungal agent', 7, NULL, 9, 33, NULL),
(100, 'Which antimalarial agent', 7, NULL, 9, 34, NULL),
(101, 'Which antiviral', 4, 1, 9, 35, NULL),
(102, 'Which complication', 7, NULL, 3, 30, NULL),
(103, 'Which experimental agent', 7, NULL, 9, 37, NULL),
(104, 'Which other antiviral', 7, NULL, 9, 35, NULL),
(105, 'Which other pathogen of public health interest detected', 7, NULL, 7, 32, NULL),
(106, 'Other corona virus', 7, NULL, 7, 44, NULL),
(107, 'Date of Birth', 2, NULL, 6, NULL, NULL),
(108, 'Healthcare worker', 8, 15, 6, NULL, NULL),
(109, 'Laboratory Worker', 8, 15, 6, NULL, NULL),
(110, 'Pregnant', 9, 16, 6, NULL, NULL),
(111, 'Sex at Birth', 4, 13, 6, NULL, NULL),
(112, 'Oxygen saturation expl', 4, 10, 14, 41, NULL),
(113, 'Gestational weeks assessment', 5, NULL, 6, 110, NULL),
(114, 'ALT/SGPT measurement', 3, NULL, 8, NULL, NULL),
(115, 'APTT/APTR measurement', 3, NULL, 8, NULL, NULL),
(116, 'AST/SGOT measurement', 3, NULL, 8, NULL, NULL),
(117, 'Antibiotic', 8, 15, 9, NULL, NULL),
(118, 'ESR measurement', 3, NULL, 8, NULL, NULL),
(119, 'Intravenous fluids', 8, 15, 9, NULL, NULL),
(120, 'Oral/orogastric fluids', 8, 15, 9, NULL, NULL),
(121, 'Influenza virus type', 7, NULL, 7, 46, NULL),
(122, 'Ability to self-care at discharge versus before illness', 4, 12, 10, NULL, NULL),
(123, 'Outcome', 4, 9, 10, NULL, NULL),
(124, 'Outcome date', 2, NULL, 10, NULL, NULL),
(125, 'Which respiratory pathogen', 7, NULL, 7, 42, NULL),
(126, 'Which virus', 7, NULL, 7, 43, NULL),
(127, 'Abdominal pain', 8, 15, 12, NULL, NULL),
(128, 'Cough with haemoptysis', 8, 15, 12, NULL, NULL),
(129, 'Fatigue/Malaise', 8, 15, 12, NULL, NULL),
(130, 'Headache', 8, 15, 12, NULL, NULL),
(131, 'duration in weeks', 5, NULL, NULL, NULL, NULL),
(132, 'History of fever', 8, 15, 12, NULL, NULL),
(133, 'Inability to walk', 8, 15, 12, NULL, NULL),
(134, 'Joint pain (arthralgia)', 8, 15, 12, NULL, NULL),
(135, 'Lower chest wall indrawing', 8, 15, 12, NULL, NULL),
(136, 'Lymphadenopathy', 8, 15, 12, NULL, NULL),
(137, 'Runny nose (rhinorrhoea)', 8, 15, 12, NULL, NULL),
(138, 'Skin rash', 8, 15, 12, NULL, NULL),
(139, 'Skin ulcers', 8, 15, 12, NULL, NULL),
(140, 'Wheezing', 8, 15, 12, NULL, NULL),
(141, 'Oxygen saturation expl', 4, 10, 5, 40, NULL),
(142, 'Which sign or symptom', 7, NULL, 4, 28, 27),
(143, 'Which sign or symptom', 7, NULL, 12, 29, 27),
(144, 'Age (years)', 5, NULL, 6, NULL, 1),
(145, 'Creatine kinase measurement', 3, NULL, 8, NULL, NULL),
(146, 'Creatinine measurement', 3, NULL, 8, NULL, NULL),
(147, 'CRP measurement', 3, NULL, 8, NULL, NULL),
(148, 'D-dimer measurement', 3, NULL, 8, NULL, NULL),
(149, 'Extracorporeal (ECMO) support', 8, 15, 13, NULL, NULL),
(150, 'ICU or High Dependency Unit admission', 8, 15, 13, NULL, NULL),
(151, 'Inotropes/vasopressors', 8, 15, 13, NULL, NULL),
(152, 'Invasive ventilation', 8, 15, 13, NULL, NULL),
(153, 'Non-invasive ventilation', 9, 16, 13, NULL, NULL),
(154, 'Prone position', 8, 15, 13, NULL, NULL),
(155, 'Renal replacement therapy (RRT) or dialysis', 8, 15, 13, NULL, NULL),
(156, 'Ferritin measurement', 3, NULL, 8, NULL, NULL),
(157, 'Haematocrit measurement', 3, NULL, 8, NULL, NULL),
(158, 'Haemoglobin measurement', 3, NULL, 8, NULL, NULL),
(159, 'IL-6 measurement', 3, NULL, 8, NULL, NULL),
(160, 'INR measurement', 3, NULL, 8, NULL, NULL),
(161, 'Lactate measurement', 3, NULL, 8, NULL, NULL),
(162, 'LDH measurement', 3, NULL, 8, NULL, NULL),
(163, 'Platelets measurement', 3, NULL, 8, NULL, NULL),
(164, 'Potassium measurement', 3, NULL, 8, NULL, NULL),
(165, 'Procalcitonin measurement', 3, NULL, 8, NULL, NULL),
(166, 'Country', 4, 5, NULL, NULL, NULL),
(167, 'Date of enrolment', 2, NULL, NULL, NULL, NULL),
(168, 'Date of follow up', 2, NULL, NULL, NULL, NULL),
(169, 'PT measurement', 3, NULL, 8, NULL, NULL),
(170, 'Sodium measurement', 3, NULL, 8, NULL, NULL),
(171, 'Total bilirubin measurement', 3, NULL, 8, NULL, NULL),
(172, 'Troponin measurement', 3, NULL, 8, NULL, NULL),
(173, 'duration in days', 5, NULL, NULL, NULL, NULL),
(174, 'Urea (BUN) measurement', 3, NULL, 8, NULL, NULL),
(175, 'specific response', 7, NULL, NULL, NULL, NULL),
(176, 'Seizures', 8, 15, 3, NULL, 20),
(177, 'Chest pain', 8, 15, 4, NULL, 8),
(178, 'Seizures', 8, 15, 4, NULL, 20),
(179, 'Altered consciousness/confusion', 8, 15, 4, NULL, 2),
(180, 'Which NSAID', 7, NULL, 9, 16, NULL),
(181, 'Oxygen saturation expl', 4, 10, NULL, NULL, NULL),
(182, 'Vomiting/Nausea', 8, 15, 4, NULL, 26),
(183, 'Cough', 8, 15, 4, NULL, 10),
(184, 'Sore throat', 8, 15, 4, NULL, 23),
(185, 'Shortness of breath', 8, 15, 4, NULL, 22),
(186, 'Diarrhoea', 8, 15, 4, NULL, 12),
(187, 'Muscle aches (myalgia)', 8, 15, 4, NULL, 15),
(188, 'Conjunctivitis', 8, 15, 4, NULL, 9),
(189, 'Severe dehydration', 8, 15, 5, NULL, 21),
(190, 'AVPU scale', 4, 2, 5, NULL, 5),
(191, 'Heart rate', 5, NULL, 5, NULL, 14),
(192, 'BP (diastolic)', 5, NULL, 5, NULL, 6),
(193, 'Glasgow Coma Score (GCS /15)', 5, NULL, 5, NULL, 13),
(194, 'Respiratory rate', 5, NULL, 5, NULL, 19),
(195, 'BP (systolic)', 5, NULL, 5, NULL, 7),
(196, 'Sternal capillary refill time >2seconds', 8, 15, 5, NULL, 24),
(197, 'Cough with sputum production', 8, 15, 4, NULL, 11),
(198, 'Temperature', 5, NULL, 5, NULL, 25),
(199, 'Non-steroidal anti-inflammatory (NSAID)', 8, 15, 9, NULL, 16),
(200, 'Angiotensin converting enzyme inhibitors (ACE inhibitors)', 8, 15, 9, NULL, 3),
(201, 'Angiotensin II receptor blockers (ARBs)', 8, 15, 9, NULL, 4),
(202, 'Angiotensin converting enzyme inhibitors (ACE inhibitors)', 8, 15, 11, NULL, 3),
(203, 'Angiotensin II receptor blockers (ARBs)', 8, 15, 11, NULL, 4),
(204, 'Non-steroidal anti-inflammatory (NSAID)', 8, 15, 11, NULL, 16),
(205, 'Shortness of breath', 8, 15, 12, NULL, 22),
(206, 'Vomiting/Nausea', 8, 15, 12, NULL, 26),
(207, 'Altered consciousness/confusion', 8, 15, 12, NULL, 2),
(208, 'Diarrhoea', 8, 15, 12, NULL, 12),
(209, 'Muscle aches (myalgia)', 8, 15, 12, NULL, 15),
(210, 'Cough', 8, 15, 12, NULL, 10),
(211, 'Seizures', 8, 15, 12, NULL, 20),
(212, 'Age (months)', 5, NULL, 6, NULL, 1),
(213, 'Conjunctivitis', 8, 15, 12, NULL, 9),
(214, 'Chest pain', 8, 15, 12, NULL, 8),
(215, 'Sore throat', 8, 15, 12, NULL, 23),
(216, 'AVPU scale', 4, 2, 14, NULL, 5),
(217, 'Temperature', 5, NULL, 14, NULL, 25),
(218, 'Sternal capillary refill time >2seconds', 8, 15, 14, NULL, 24),
(219, 'BP (diastolic)', 5, NULL, 14, NULL, 6),
(220, 'Severe dehydration', 8, 15, 14, NULL, 21),
(221, 'Heart rate', 5, NULL, 14, NULL, 14),
(222, 'BP (systolic)', 5, NULL, 14, NULL, 7),
(223, 'Glasgow Coma Score (GCS /15)', 5, NULL, 14, NULL, 13),
(224, 'Respiratory rate', 5, NULL, 14, NULL, 19),
(225, 'Cough with sputum production', 8, 15, 12, NULL, 11),
(226, 'WBC count measurement', 3, NULL, 8, NULL, NULL),
(227, 'Which other co-morbidities', 7, NULL, 2, 62, NULL),
(228, 'Date of ICU/HDU admission', 2, NULL, 13, 150, NULL),
(229, 'ICU/HDU discharge date', 2, NULL, 13, 150, NULL),
(230, 'Date of ICU/HDU admission', 2, NULL, 13, 150, NULL),
(231, 'ICU/HDU discharge date', 2, NULL, 13, 150, NULL),
(232, 'Which antibiotic', 7, NULL, 9, 117, NULL),
(233, 'Total duration ICU/HCU', 5, NULL, 13, 150, 173),
(234, 'Total duration Oxygen Therapy', 5, NULL, 13, 39, 173),
(235, 'Total duration Non-invasive ventilation', 5, NULL, 13, 153, 173),
(236, 'Total duration Invasive ventilation', 5, NULL, 13, 152, 173),
(237, 'Total duration ECMO', 5, NULL, 13, 149, 173),
(238, 'Total duration Prone position', 5, NULL, 13, 154, 173),
(239, 'Total duration RRT or dyalysis', 5, NULL, 13, 155, 173),
(240, 'Total duration Inotropes/vasopressors', 5, NULL, 13, 151, 173),
(241, 'Systemic anticoagulation', 8, 15, 9, NULL, NULL),
(242, 'Facility name', 7, NULL, NULL, NULL, NULL),
(243, 'Loss of smell', 8, 15, NULL, NULL, NULL),
(244, 'Loss of taste', 8, 15, NULL, NULL, NULL),
(245, 'FiO2 value', 10, NULL, 13, 152, NULL),
(246, 'PaO2 value', 10, NULL, 13, 152, NULL),
(247, 'PaCO2 value', 10, NULL, 13, 152, NULL),
(248, 'Plateau pressure value', 10, NULL, 13, 152, NULL),
(249, 'PEEP value', 10, NULL, 13, 152, NULL),
(250, 'Loss of smell daily', 8, 15, 4, NULL, 243),
(251, 'Loss of taste daily', 8, 15, 4, NULL, 244),
(252, 'Loss of smell signs', 8, 15, 12, NULL, 243),
(253, 'Loss of taste signs', 8, 15, 12, NULL, 244),
(254, 'Which antiviral', 4, 1, 11, NULL, 101),
(255, 'Which other antiviral', 7, NULL, 11, 254, 104);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_questiontype`
--

DROP TABLE IF EXISTS `tb_questiontype`;
CREATE TABLE `tb_questiontype` (
  `questionTypeID` int(10) NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '(pt-br) Descrição.\r\n(en) description.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tabela truncada antes do insert `tb_questiontype`
--

TRUNCATE TABLE `tb_questiontype`;
--
-- Despejando dados para a tabela `tb_questiontype`
--

INSERT INTO `tb_questiontype` (`questionTypeID`, `description`) VALUES
(1, 'Boolean_Question'),
(2, 'Date question'),
(3, 'Laboratory question'),
(4, 'List question'),
(5, 'Number question'),
(6, 'PNNot_done_Question'),
(7, 'Text_Question'),
(8, 'YNU_Question'),
(9, 'YNUN_Question'),
(10, 'Ventilation question');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_user`
--

DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `userID` bigint(20) UNSIGNED NOT NULL,
  `login` varchar(255) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `regionalCouncilCode` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `eMail` varchar(255) DEFAULT NULL,
  `foneNumber` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_user`
--

TRUNCATE TABLE `tb_user`;
--
-- Despejando dados para a tabela `tb_user`
--

INSERT INTO `tb_user` (`userID`, `login`, `firstName`, `lastName`, `regionalCouncilCode`, `password`, `eMail`, `foneNumber`) VALUES
(1, 'admin', 'Administrador', 'Teste', NULL, '$2a$12$yCNRVs6A1VwyUclQONkxyOxZC/8tOLUOHzt/JWquNHlak6fcOB7/m', NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tb_userrole`
--

DROP TABLE IF EXISTS `tb_userrole`;
CREATE TABLE `tb_userrole` (
  `userID` int(11) NOT NULL,
  `groupRoleID` int(11) NOT NULL,
  `hospitalUnitID` int(11) NOT NULL,
  `creationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expirationDate` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Tabela truncada antes do insert `tb_userrole`
--

TRUNCATE TABLE `tb_userrole`;
--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `tb_assessmentquestionnaire`
--
ALTER TABLE `tb_assessmentquestionnaire`
  ADD PRIMARY KEY (`participantID`,`hospitalUnitID`,`questionnaireID`),
  ADD KEY `FKtb_Assessm665217` (`hospitalUnitID`),
  ADD KEY `FKtb_Assessm419169` (`questionnaireID`);

--
-- Índices de tabela `tb_crfforms`
--
ALTER TABLE `tb_crfforms`
  ADD PRIMARY KEY (`crfFormsID`),
  ADD KEY `FKtb_CRFForm860269` (`questionnaireID`);

--
-- Índices de tabela `tb_formrecord`
--
ALTER TABLE `tb_formrecord`
  ADD PRIMARY KEY (`formRecordID`),
  ADD KEY `FKtb_FormRec2192` (`crfFormsID`),
  ADD KEY `FKtb_FormRec984256` (`participantID`,`hospitalUnitID`,`questionnaireID`);

--
-- Índices de tabela `tb_grouprole`
--
ALTER TABLE `tb_grouprole`
  ADD PRIMARY KEY (`groupRoleID`),
  ADD UNIQUE KEY `groupRoleID` (`groupRoleID`);

--
-- Índices de tabela `tb_grouprolepermission`
--
ALTER TABLE `tb_grouprolepermission`
  ADD PRIMARY KEY (`groupRoleID`,`permissionID`),
  ADD KEY `FKtb_GroupRo893005` (`permissionID`);

--
-- Índices de tabela `tb_hospitalunit`
--
ALTER TABLE `tb_hospitalunit`
  ADD PRIMARY KEY (`hospitalUnitID`);

--
-- Índices de tabela `tb_language`
--
ALTER TABLE `tb_language`
  ADD PRIMARY KEY (`languageID`);

--
-- Índices de tabela `tb_listofvalues`
--
ALTER TABLE `tb_listofvalues`
  ADD PRIMARY KEY (`listOfValuesID`),
  ADD KEY `FKtb_ListOfV184108` (`listTypeID`);

--
-- Índices de tabela `tb_listtype`
--
ALTER TABLE `tb_listtype`
  ADD PRIMARY KEY (`listTypeID`);

--
-- Índices de tabela `tb_multilanguage`
--
ALTER TABLE `tb_multilanguage`
  ADD PRIMARY KEY (`languageID`,`description`);

--
-- Índices de tabela `tb_notificationrecord`
--
ALTER TABLE `tb_notificationrecord`
  ADD PRIMARY KEY (`userID`,`profileID`,`hospitalUnitID`,`tableName`,`rowdID`,`changedOn`,`operation`);

--
-- Índices de tabela `tb_participant`
--
ALTER TABLE `tb_participant`
  ADD PRIMARY KEY (`participantID`);

--
-- Índices de tabela `tb_permission`
--
ALTER TABLE `tb_permission`
  ADD PRIMARY KEY (`permissionID`),
  ADD UNIQUE KEY `permissionID` (`permissionID`);

--
-- Índices de tabela `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `userID` (`userID`),
  ADD UNIQUE KEY `login` (`login`);

--
-- Índices de tabela `tb_userrole`
--
ALTER TABLE `tb_userrole`
  ADD PRIMARY KEY (`userID`,`groupRoleID`,`hospitalUnitID`),
  ADD KEY `FKtb_UserRol864770` (`groupRoleID`),
  ADD KEY `FKtb_UserRol324331` (`hospitalUnitID`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `tb_crfforms`
--
ALTER TABLE `tb_crfforms`
  MODIFY `crfFormsID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `tb_formrecord`
--
ALTER TABLE `tb_formrecord`
  MODIFY `formRecordID` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_grouprole`
--
ALTER TABLE `tb_grouprole`
  MODIFY `groupRoleID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `tb_hospitalunit`
--
ALTER TABLE `tb_hospitalunit`
  MODIFY `hospitalUnitID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `tb_language`
--
ALTER TABLE `tb_language`
  MODIFY `languageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `tb_listofvalues`
--
ALTER TABLE `tb_listofvalues`
  MODIFY `listOfValuesID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=308;

--
-- AUTO_INCREMENT de tabela `tb_listtype`
--
ALTER TABLE `tb_listtype`
  MODIFY `listTypeID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de tabela `tb_participant`
--
ALTER TABLE `tb_participant`
  MODIFY `participantID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `tb_permission`
--
ALTER TABLE `tb_permission`
  MODIFY `permissionID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `userID` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
