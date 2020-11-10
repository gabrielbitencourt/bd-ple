/* Arquivo com as nomes de tabelas seguidas fielmente do banco de dados, não usar como modelo no código */
interface tb_AssessmentQuestionnaire {
	participantID: number;
	hospitalUnitID: number;
	questionnaireID: number;
};

interface tb_CRFForms {
	crfFormsID: number;
	questionnaireID: number;
	description: string;
};

interface tb_FormRecord {
	formRecordID: number;
	participantID: number;
	hospitalUnitID: number;
	questionnaireID: number;
	crfFormsID: number;
	dtRegistroForm: string;
};

interface tb_GroupRole {
	groupRoleID: number;
	description: string;
};

interface tb_GroupRolePermission {
	groupRoleID: number;
	permissionID: number;
};

interface tb_HospitalUnit {
	hospitalUnitID: number;
	hospitalUnitName: string;
};

interface tb_ListOfValues {
	listOfValuesID: number;
	listTypeID: number;
	description: string;
};

interface tb_ListType {
	listTypeID: number;
	description: string;
};

interface tb_NotificationRecord {
	userID: number;
	profileID: number;
	hospitalUnitID: number;
	tableName: string;
	rowdID: number;
	changedOn: string;
	operation: string;
	log: string;
};

interface tb_Participant {
	participantID: number;
	medicalRecord: string;
};

interface tb_Permission {
	permissionID: number;
	description: string;
};

interface tb_QuestionGroup {
	questionGroupID: number;
	description: string;
	comment?: string;
};

interface tb_QuestionGroupForm {
	crfFormsID: number;
	questionID: number;
	questionOrder: number;
};

interface tb_QuestionGroupFormRecord {
	questionGroupFormRecordID: number;
	formRecordID: number;
	crfFormsID: number;
	questionID: number;
	listOfValuesID?: number;
	answer?: string;
};

interface tb_Questionnaire {
	questionnaireID: number;
	description: string;
};

interface tb_Questions {
	questionID: number;
	description: string;
	questionTypeID: number;
	listTypeID?: number;
	questionGroupID?: number;
	subordinateTo?: number;
	isAbout?: number;
};

interface tb_QuestionType {
	questionTypeID: number;
	description: string;
};

interface tb_RelationType {
	relationTypeID: number;
	description: string;
};

interface tb_TermType {
	termTypeID: number;
	description: string;
};

interface tb_User {
	userID: number;
	login: string;
	firstName: string;
	lastName: string;
	regionalCouncilCode?: string;
	password: string;
	eMail?: string;
	foneNumber?: string;
};

interface tb_UserRole {
	userID: number;
	groupRoleID: number;
	hospitalUnitID: number;
	creationDate: string;
	expirationDate?: string;
};