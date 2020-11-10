-- Montando formulario em Ingles
select crfformsid, questionid, questionorder, 
       formulario, 
       (case when questiongroup is null then '' else questiongroup end) as questionGroup,
	   (case when QuestaoSubordinadaA is null then Question
	         else QuestaoSubordinadaA || ': ' || Question end) as Question,
	   QuestionType, listTypeResposta, QuestaoSubordinadaA, QuestaoReferenteA
from (
select t5.crfformsid, t1.questionid, t9.questionorder,
       t5.description as formulario,
       (select t2.description from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as questionGroup,
        t1.description as question,
	   (select t3.description as questionType from tb_questiontype t3 where t3.questiontypeid = t1.questiontypeid) as questionType,
	   (select t6.description from tb_listType t6 where t6.listtypeid = t1.listtypeid) as listTypeResposta,
	   (select description from tb_questions t7 where t7.questionId = t1.subordinateTo) as QuestaoSubordinadaA,
	   (select description from tb_questions t8 where t8.questionId = t1.isabout) as QuestaoReferenteA
from tb_questions t1,  tb_crfForms t5, tb_questionGroupForm t9
where 
t9.crfformsid = t5.crfformsid and t9.questionid = t1.questionid
) as tabela_Formulario
Order by crfformsid, questionorder

-- montando formulario em Portugues
select crfformsid, questionid, questionorder,
       translate('pt-br', formulario) as formulario,
	   translate('pt-br', questionGroup) as questionGroup,
	   translate('pt-br', commentQuestionGroup) as commentQuestionGroup,
       translate('pt-br', question) as question,
	  -- question,
	   questionType,
       listtyperesposta,
	   translate('pt-br', questaosubordinadaa) as questionSubordinada,
	   translate ('pt-br', questaoreferentea) as questaoReferentea
from (
select crfformsid, questionid, questionorder, 
       formulario, 
       (case when questiongroup is null then '' else questiongroup end) as questionGroup,
	   (case when commentquestiongroup is null then '' else commentquestiongroup end) as commentquestiongroup,
	   Question,
	   QuestionType, listTypeResposta, QuestaoSubordinadaA, QuestaoReferenteA
from (
select t5.crfformsid, t1.questionid, t9.questionorder,
       t5.description as formulario,
       (select t2.description from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as questionGroup,
       (select t2.comment from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as commentquestionGroup,
	    t1.description as question,
	   (select t3.description as questionType from tb_questiontype t3 where t3.questiontypeid = t1.questiontypeid) as questionType,
	   (select t6.description from tb_listType t6 where t6.listtypeid = t1.listtypeid) as listTypeResposta,
	   (select description from tb_questions t7 where t7.questionId = t1.subordinateTo) as QuestaoSubordinadaA,
	   (select description from tb_questions t8 where t8.questionId = t1.isabout) as QuestaoReferenteA
from tb_questions t1,  tb_crfForms t5, tb_questionGroupForm t9
where 
t9.crfformsid = t5.crfformsid and t9.questionid = t1.questionid
) as tabela_Formulario ) as tb_Questionario
Order by crfformsid, questionorder


-- montando formulario em Portugues com respostas
select crfformsid, questionid, questionorder,
       translate('pt-br', formulario) as formulario,
	   translate('pt-br', questionGroup) as questionGroup,
	   translate('pt-br', commentQuestionGroup) as commentQuestionGroup,
       translate('pt-br', question) as question,
	  -- question,
	   questionType,
       listtyperesposta,
	   (select  STRING_AGG(translate('pt-br',tlv.description), ' | ') as listofvalue from tb_listofvalues tlv
         where listtypeid = tb_Questionario.listtypeid ) as listofvalue,
	   (select STRING_AGG(cast(tlv.listofvaluesid as varchar), ' | ') as listtypeID from tb_listofvalues tlv
          where listtypeid = tb_Questionario.listtypeid ) as listofvaluesid,  
	   translate('pt-br', questaosubordinada_a) as questionSubordinadaa,
	   translate ('pt-br', questaoreferente_a) as questaoReferentea
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
where 
t9.crfformsid = t5.crfformsid and t9.questionid = t1.questionid
) as tabela_Formulario ) as tb_Questionario
Order by crfformsid, questionorder



-- Listando valores de resposta padronizados
select *, translate('pt-br', t1.description) 
from tb_listofvalues t1, tb_listtype t2
where t1.listtypeid <> 5 and t2.listtypeid = t1.listtypeid
order by t1.listtypeid, t1.listofvaluesid


-- Montando formulario associando-o a ontologia
select crfformsid, questionid, questionorder, 
       formulario, ontologyURI_Form,
       (case when questiongroup is null then '' else questiongroup end) as questionGroup, ontologyURI_QGroup,
	    Question, ontologyURI_Question,
	    QuestionType, ontologyURI_QType, 
	    (case when listTypeResposta is null then '' else listTypeResposta end) as listTypeResposta, ontologyURI_LType
from (
select t5.crfformsid, t1.questionid, t9.questionorder,
        t5.description as formulario,
	     ontologyURI ('COVIDCRFRAPID', 'tb_crfforms', t5.crfformsid ) as ontologyURI_Form,
		(select t2.description from tb_questiongroup t2 where t2.questiongroupid = t1.questiongroupid) as questionGroup,
	     ontologyURI ('COVIDCRFRAPID', 'tb_questiongroup', t1.questiongroupid ) as ontologyURI_QGroup,
         t1.description as question,
	    ontologyURI ('COVIDCRFRAPID', 'tb_questions', t1.questionid ) as ontologyURI_Question,
	    (select t3.description as questionType from tb_questiontype t3 where t3.questiontypeid = t1.questiontypeid) as questionType,
	    ontologyURI ('COVIDCRFRAPID', 'tb_questiontype', t1.questiontypeid ) as ontologyURI_QType,  
     	(select t6.description from tb_listType t6 where t6.listtypeid = t1.listtypeid) as listTypeResposta,
	     ontologyURI ('COVIDCRFRAPID', 'tb_listtype', t1.listtypeid ) as ontologyURI_LType  	
from tb_questions t1,  tb_crfForms t5, tb_questionGroupForm t9
where 
t9.crfformsid = t5.crfformsid and t9.questionid = t1.questionid
) as tabela_Formulario
Order by crfformsid, questionorder


-- Relacionando Listas de respostas padronizadas à Ontologia


