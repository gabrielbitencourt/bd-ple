SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

DELIMITER $$

DROP FUNCTION IF EXISTS `ontologyuri`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ontologyuri` (`ontologyacronym` VARCHAR(500), `tablename` VARCHAR(500), `identifier` INTEGER) RETURNS VARCHAR(500) CHARSET utf8 BEGIN
   declare v_ontologyURI character varying (255);
   
	  
   SELECT t3.ontologyuri into v_ontologyURI
   from 
       tb_QuestionnairePartsTable t2, tb_QuestionnairePartsOntology t3, tb_ontology t4
   where
	t4.acronym = ontologyAcronym and -- Identifica a ontologia que se deseja relacionar
	t2.description = tableName and
	t3.ontologyID = t4.OntologyID and
	t3.questionnairepartstableid = t2.questionnairepartstableid and
	t3.questionnairepartsid = identifier;
  
    if (v_ontologyURI is null) then  
        SET v_ontologyURI = '';
    END IF;
	  
    RETURN v_ontologyURI;
END$$

DROP FUNCTION IF EXISTS `translate`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `translate` (`lng` VARCHAR(255), `val` VARCHAR(500)) RETURNS VARCHAR(500) CHARSET utf8 BEGIN
   declare descriptionLNG varchar (500);
 
	
      select t1.descriptionlang into descriptionLNG
      from tb_multilanguage t1, tb_language t2 
	  where t2.description = lng and t1.languageId = t2.languageID and upper(t1.description) = upper(val);
  
      if (descriptionLNG is null) then  
	    SET descriptionLNG = '';
	  END IF;
	  
      RETURN descriptionLNG;
END$$
COMMIT;