CREATE TABLE tb_QuestionGroupFormRecord (
  questionGroupFormRecordID int(10) NOT NULL AUTO_INCREMENT, 
  formRecordID              int(10) NOT NULL, 
  crfFormsID                int(10) NOT NULL, 
  questionID                int(10) NOT NULL, 
  listOfValuesID            int(10), 
  answer                    varchar(512), 
  PRIMARY KEY (questionGroupFormRecordID)) comment='(pt-br) Tabela para registro da resposta associada a uma questão de um agrupamento de um formulário referente a um questionario de avaliação.
(en) Form record table.';
CREATE TABLE tb_AssessmentQuestionnaire (
  participantID   int(10) NOT NULL comment '(pt-br)  Chave estrangeira para a tabela tb_Patient.
(en) Foreign key to the tb_Patient table.', 
  hospitalUnitID  int(10) NOT NULL comment '(pt-br) Chave estrangeira para tabela tb_HospitalUnit.
(en) Foreign key for the tp_HospitalUnit table.', 
  questionnaireID int(10) NOT NULL, 
  PRIMARY KEY (participantID, 
  hospitalUnitID, 
  questionnaireID));
CREATE TABLE tb_Participant (
  participantID int(10) NOT NULL AUTO_INCREMENT, 
  medicalRecord varchar(255) NOT NULL comment '(pt-br) prontuário do paciente. 
(en) patient medical record.', 
  PRIMARY KEY (participantID)) comment='(pt-br) Tabela para registros de pacientes.
(en) Table for patient records.';
CREATE TABLE tb_HospitalUnit (
  hospitalUnitID   int(10) NOT NULL AUTO_INCREMENT, 
  hospitalUnitName varchar(500) NOT NULL comment '(pt-br) Nome da unidade hospitalar.
(en) Name of the hospital unit.', 
  PRIMARY KEY (hospitalUnitID)) comment='(pt-br) Tabela para identificação de unidades hospitalares.
(en) Table for hospital units identification.';
CREATE TABLE tb_ListType (
  listTypeID  int(10) NOT NULL AUTO_INCREMENT, 
  description varchar(255) NOT NULL comment '(pt-br) Descrição.
(en) description.', 
  PRIMARY KEY (listTypeID));
CREATE TABLE tb_QuestionType (
  questionTypeID int(10) NOT NULL AUTO_INCREMENT, 
  description    varchar(255) NOT NULL comment '(pt-br) Descrição.
(en) description.', 
  CONSTRAINT questionTypeID 
    PRIMARY KEY (questionTypeID));
CREATE TABLE tb_QuestionGroup (
  questionGroupID int(10) NOT NULL AUTO_INCREMENT, 
  description     varchar(255) NOT NULL comment '(pt-br) Descrição.
(en) description.', 
  comment         varchar(255), 
  PRIMARY KEY (questionGroupID)) comment='Relacionado ao Question Group da ontologia relaciona as diversas sessoes existentes nos formularios do CRF COVID-19';
CREATE TABLE tb_ListOfValues (
  listOfValuesID int(10) NOT NULL AUTO_INCREMENT, 
  listTypeID     int(10) NOT NULL, 
  description    varchar(255) NOT NULL comment '(pt-br) Descrição.
(en) description.', 
  PRIMARY KEY (listOfValuesID)) comment='(pt-br) Representa todos os valores padronizados do formulário.
(en) Represents all standard values on the form.';
CREATE TABLE tb_CRFForms (
  crfFormsID      int(10) NOT NULL AUTO_INCREMENT, 
  questionnaireID int(10) NOT NULL, 
  description     varchar(255) NOT NULL comment '(pt-br) Descrição .
(en) description.', 
  PRIMARY KEY (crfFormsID)) comment='(pt-br)
tb_CRFForms identifica o tipo do formulario refere-se ao Questionnaire Subsection da Ontologia:
Admissão - Modulo 1
Acompanhamento - Modulo 2
Desfecho - Modulo 3
(en)
tb_CRFForms identifies the type of the form refers to the Questionnaire Subsection of Ontology: Admission - Module 1 Monitoring - Module 2 Outcome - Module 3';
CREATE TABLE tb_Questions (
  questionID      int(10) NOT NULL AUTO_INCREMENT, 
  description     varchar(255) NOT NULL comment '(pt-br) Descrição.
(en) description.', 
  questionTypeID  int(10) NOT NULL comment '(pt-br) Chave estrangeira para tabela tb_QuestionsTypes.
(en) Foreign key for the tp_QuestionsTypes table.', 
  listTypeID      int(10), 
  questionGroupID int(10), 
  subordinateTo   int(10), 
  isAbout         int(10), 
  PRIMARY KEY (questionID));
CREATE TABLE tb_Questionnaire (
  questionnaireID int(10) NOT NULL AUTO_INCREMENT, 
  description     varchar(255) NOT NULL, 
  PRIMARY KEY (questionnaireID));
CREATE TABLE tb_QuestionGroupForm (
  crfFormsID    int(10) NOT NULL, 
  questionID    int(10) NOT NULL, 
  questionOrder int(10) NOT NULL, 
  PRIMARY KEY (crfFormsID, 
  questionID));
CREATE TABLE tb_FormRecord (
  formRecordID    int(10) NOT NULL AUTO_INCREMENT, 
  participantID   int(10) NOT NULL, 
  hospitalUnitID  int(10) NOT NULL, 
  questionnaireID int(10) NOT NULL, 
  crfFormsID      int(10) NOT NULL, 
  dtRegistroForm  timestamp NOT NULL, 
  PRIMARY KEY (formRecordID));
CREATE TABLE tb_Ontology (
  ontologyID  int(10) NOT NULL AUTO_INCREMENT, 
  description varchar(255) NOT NULL, 
  version     varchar(255) NOT NULL, 
  dtRelease   timestamp NULL, 
  license     varchar(255) NOT NULL, 
  acronym     varchar(255) NOT NULL, 
  PRIMARY KEY (ontologyID));
CREATE TABLE tb_OntologyTerms (
  ontologyURI varchar(255) NOT NULL, 
  ontologyID  int(10) NOT NULL, 
  termTypeID  int(11) NOT NULL, 
  description varchar(255), 
  PRIMARY KEY (ontologyURI));
CREATE TABLE tb_QuestionnaireParts (
  questionnairePartsID      int(10) NOT NULL, 
  questionnairePartsTableID int(10) NOT NULL, 
  PRIMARY KEY (questionnairePartsID, 
  questionnairePartsTableID));
CREATE TABLE tb_QuestionnairePartsTable (
  questionnairePartsTableID int(10) NOT NULL AUTO_INCREMENT, 
  description               varchar(255) NOT NULL, 
  PRIMARY KEY (questionnairePartsTableID));
CREATE TABLE tb_QuestionnairePartsOntology (
  ontologyURI               varchar(255) NOT NULL, 
  questionnairePartsID      int(10) NOT NULL, 
  questionnairePartsTableID int(10) NOT NULL, 
  PRIMARY KEY (ontologyURI, 
  questionnairePartsID, 
  questionnairePartsTableID));
CREATE TABLE tb_MultiLanguage (
  languageID      int(11) NOT NULL, 
  description     varchar(500) NOT NULL, 
  descriptionLang varchar(500) NOT NULL, 
  PRIMARY KEY (languageID, 
  description));
CREATE TABLE tb_Language (
  languageID  int(11) NOT NULL AUTO_INCREMENT, 
  description varchar(255) NOT NULL, 
  PRIMARY KEY (languageID));
CREATE TABLE tb_TermType (
  termTypeID  int(11) NOT NULL AUTO_INCREMENT, 
  description varchar(255) NOT NULL comment 'Description of term type. Example: Class, Object Property, Data Property, Individual', 
  PRIMARY KEY (termTypeID));
CREATE TABLE tb_RelationOntology (
  ontologyURI               varchar(255) NOT NULL, 
  questionnairePartsID      int(10) NOT NULL, 
  questionnairePartsTableID int(10) NOT NULL, 
  predicate                 varchar(255) NOT NULL, 
  relationTypeID            int(11) NOT NULL, 
  rangeURI                  varchar(255), 
  rangeDataType             varchar(255), 
  PRIMARY KEY (ontologyURI, 
  questionnairePartsID, 
  questionnairePartsTableID, 
  predicate));
CREATE TABLE tb_RelationType (
  relationTypeID int(11) NOT NULL AUTO_INCREMENT, 
  description    varchar(255) NOT NULL, 
  PRIMARY KEY (relationTypeID));
CREATE TABLE tb_User (
  userID              int(11) NOT NULL AUTO_INCREMENT, 
  login               varchar(255) NOT NULL UNIQUE, 
  firstName           varchar(100) NOT NULL, 
  lastName            varchar(100) NOT NULL, 
  regionalCouncilCode varchar(255), 
  password            varchar(255) NOT NULL, 
  eMail               varchar(255), 
  foneNumber          varchar(255), 
  PRIMARY KEY (userID));
CREATE TABLE tb_GroupRole (
  groupRoleID int(11) NOT NULL AUTO_INCREMENT, 
  description varchar(255) NOT NULL, 
  PRIMARY KEY (groupRoleID));
CREATE TABLE tb_UserRole (
  userID         int(11) NOT NULL, 
  groupRoleID    int(11) NOT NULL, 
  hospitalUnitID int(10) NOT NULL, 
  creationDate   timestamp NOT NULL, 
  expirationDate timestamp NULL, 
  PRIMARY KEY (userID, 
  groupRoleID, 
  hospitalUnitID));
CREATE TABLE tb_NotificationRecord (
  userID         int(11) NOT NULL, 
  profileID      int(11) NOT NULL, 
  hospitalUnitID int(10) NOT NULL, 
  tableName      varchar(255) NOT NULL, 
  rowdID         int(11) NOT NULL, 
  changedOn      timestamp NOT NULL, 
  operation      varchar(1) NOT NULL comment '(I) Insert
(U) Update
(D) Delete', 
  log            text, 
  PRIMARY KEY (userID, 
  profileID, 
  hospitalUnitID, 
  tableName, 
  rowdID, 
  changedOn, 
  operation));
CREATE TABLE tb_Permission (
  permissionID int(11) NOT NULL AUTO_INCREMENT, 
  description  varchar(255) NOT NULL, 
  PRIMARY KEY (permissionID));
CREATE TABLE tb_GroupRolePermission (
  groupRoleID  int(11) NOT NULL, 
  permissionID int(11) NOT NULL, 
  PRIMARY KEY (groupRoleID, 
  permissionID));
ALTER TABLE tb_AssessmentQuestionnaire ADD CONSTRAINT FKtb_Assessm313417 FOREIGN KEY (participantID) REFERENCES tb_Participant (participantID);
ALTER TABLE tb_AssessmentQuestionnaire ADD CONSTRAINT FKtb_Assessm665217 FOREIGN KEY (hospitalUnitID) REFERENCES tb_HospitalUnit (hospitalUnitID);
ALTER TABLE tb_ListOfValues ADD CONSTRAINT FKtb_ListOfV184108 FOREIGN KEY (listTypeID) REFERENCES tb_ListType (listTypeID);
ALTER TABLE tb_Questions ADD CONSTRAINT FKtb_Questio240796 FOREIGN KEY (listTypeID) REFERENCES tb_ListType (listTypeID);
ALTER TABLE tb_Questions ADD CONSTRAINT FKtb_Questio684913 FOREIGN KEY (questionTypeID) REFERENCES tb_QuestionType (questionTypeID);
ALTER TABLE tb_AssessmentQuestionnaire ADD CONSTRAINT FKtb_Assessm419169 FOREIGN KEY (questionnaireID) REFERENCES tb_Questionnaire (questionnaireID);
ALTER TABLE tb_CRFForms ADD CONSTRAINT FKtb_CRFForm860269 FOREIGN KEY (questionnaireID) REFERENCES tb_Questionnaire (questionnaireID);
ALTER TABLE tb_QuestionGroupFormRecord ADD CONSTRAINT FKtb_Questio928457 FOREIGN KEY (listOfValuesID) REFERENCES tb_ListOfValues (listOfValuesID);
ALTER TABLE tb_Questions ADD CONSTRAINT FKtb_Questio808495 FOREIGN KEY (questionGroupID) REFERENCES tb_QuestionGroup (questionGroupID);
ALTER TABLE tb_QuestionGroupForm ADD CONSTRAINT FKtb_Questio659154 FOREIGN KEY (crfFormsID) REFERENCES tb_CRFForms (crfFormsID);
ALTER TABLE tb_QuestionGroupForm ADD CONSTRAINT FKtb_Questio124287 FOREIGN KEY (questionID) REFERENCES tb_Questions (questionID);
ALTER TABLE tb_Questions ADD CONSTRAINT SubordinateTo FOREIGN KEY (subordinateTo) REFERENCES tb_Questions (questionID);
ALTER TABLE tb_QuestionGroupFormRecord ADD CONSTRAINT FKtb_Questio489549 FOREIGN KEY (crfFormsID, questionID) REFERENCES tb_QuestionGroupForm (crfFormsID, questionID);
ALTER TABLE tb_Questions ADD CONSTRAINT isAbout FOREIGN KEY (isAbout) REFERENCES tb_Questions (questionID);
ALTER TABLE tb_FormRecord ADD CONSTRAINT FKtb_FormRec2192 FOREIGN KEY (crfFormsID) REFERENCES tb_CRFForms (crfFormsID);
ALTER TABLE tb_FormRecord ADD CONSTRAINT FKtb_FormRec984256 FOREIGN KEY (participantID, hospitalUnitID, questionnaireID) REFERENCES tb_AssessmentQuestionnaire (participantID, hospitalUnitID, questionnaireID);
ALTER TABLE tb_QuestionGroupFormRecord ADD CONSTRAINT FKtb_Questio935723 FOREIGN KEY (formRecordID) REFERENCES tb_FormRecord (formRecordID);
ALTER TABLE tb_OntologyTerms ADD CONSTRAINT FKtb_Ontolog722236 FOREIGN KEY (ontologyID) REFERENCES tb_Ontology (ontologyID);
ALTER TABLE tb_QuestionnaireParts ADD CONSTRAINT FKtb_Questio42774 FOREIGN KEY (questionnairePartsTableID) REFERENCES tb_QuestionnairePartsTable (questionnairePartsTableID);
ALTER TABLE tb_QuestionnairePartsOntology ADD CONSTRAINT FKtb_Questio144645 FOREIGN KEY (ontologyURI) REFERENCES tb_OntologyTerms (ontologyURI);
ALTER TABLE tb_QuestionnairePartsOntology ADD CONSTRAINT FKtb_Questio773521 FOREIGN KEY (questionnairePartsID, questionnairePartsTableID) REFERENCES tb_QuestionnaireParts (questionnairePartsID, questionnairePartsTableID);
ALTER TABLE tb_MultiLanguage ADD CONSTRAINT FKtb_MultiLa36028 FOREIGN KEY (languageID) REFERENCES tb_Language (languageID);
ALTER TABLE tb_OntologyTerms ADD CONSTRAINT FKtb_Ontolog677035 FOREIGN KEY (termTypeID) REFERENCES tb_TermType (termTypeID);
ALTER TABLE tb_RelationOntology ADD CONSTRAINT FKtb_Relatio952071 FOREIGN KEY (relationTypeID) REFERENCES tb_RelationType (relationTypeID);
ALTER TABLE tb_RelationOntology ADD CONSTRAINT FKtb_Relatio885128 FOREIGN KEY (ontologyURI, questionnairePartsID, questionnairePartsTableID) REFERENCES tb_QuestionnairePartsOntology (ontologyURI, questionnairePartsID, questionnairePartsTableID);
ALTER TABLE tb_RelationOntology ADD CONSTRAINT FKtb_Relatio361398 FOREIGN KEY (predicate) REFERENCES tb_OntologyTerms (ontologyURI);
ALTER TABLE tb_UserRole ADD CONSTRAINT FKtb_UserRol401578 FOREIGN KEY (userID) REFERENCES tb_User (userID);
ALTER TABLE tb_UserRole ADD CONSTRAINT FKtb_UserRol864770 FOREIGN KEY (groupRoleID) REFERENCES tb_GroupRole (groupRoleID);
ALTER TABLE tb_UserRole ADD CONSTRAINT FKtb_UserRol324331 FOREIGN KEY (hospitalUnitID) REFERENCES tb_HospitalUnit (hospitalUnitID);
ALTER TABLE tb_NotificationRecord ADD CONSTRAINT FKtb_Notific397621 FOREIGN KEY (userID, profileID, hospitalUnitID) REFERENCES tb_UserRole (userID, groupRoleID, hospitalUnitID);
ALTER TABLE tb_GroupRolePermission ADD CONSTRAINT FKtb_GroupRo425613 FOREIGN KEY (groupRoleID) REFERENCES tb_GroupRole (groupRoleID);
ALTER TABLE tb_GroupRolePermission ADD CONSTRAINT FKtb_GroupRo893005 FOREIGN KEY (permissionID) REFERENCES tb_Permission (permissionID);
