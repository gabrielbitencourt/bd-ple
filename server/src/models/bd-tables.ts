export interface tb_AssessmentQuestionnaire {
	participantID: number;
	hospitalUnitID: number;
	questionnaireID: number;
};

export interface tb_CRFForms {
	crfFormsID: number;
	questionnaireID: number;
	description: string;
};

export interface tb_FormRecord {
	formRecordID: number;
	participantID: number;
	hospitalUnitID: number;
	questionnaireID: number;
	crfFormsID: number;
	dtRegistroForm: string;
};

export interface tb_GroupRole {
	groupRoleID: number;
	description: string;
};

export interface tb_GroupRolePermission {
	groupRoleID: number;
	permissionID: number;
};

export interface tb_HospitalUnit {
	hospitalUnitID: number;
	hospitalUnitName: string;
};

export interface tb_ListOfValues {
	listOfValuesID: number;
	listTypeID: number;
	description: string;
};

export interface tb_ListType {
	listTypeID: number;
	description: string;
};

export interface tb_NotificationRecord {
	userID: number;
	profileID: number;
	hospitalUnitID: number;
	tableName: string;
	rowdID: number;
	changedOn: string;
	operation: string;
	log: string;
};

export interface tb_Participant {
	participantID: number;
	medicalRecord: string;
};

export interface tb_Permission {
	permissionID: number;
	description: string;
};

export interface tb_QuestionGroup {
	questionGroupID: number;
	description: string;
	comment?: string;
};

export interface tb_QuestionGroupForm {
	crfFormsID: number;
	questionID: number;
	questionOrder: number;
};

export interface tb_QuestionGroupFormRecord {
	questionGroupFormRecordID: number;
	formRecordID: number;
	crfFormsID: number;
	questionID: number;
	listOfValuesID?: number;
	answer?: string;
};

export interface tb_Questionnaire {
	questionnaireID: number;
	description: string;
};

export interface tb_Questions {
	questionID: number;
	description: string;
	questionTypeID: number;
	listTypeID?: number;
	questionGroupID?: number;
	subordinateTo?: number;
	isAbout?: number;
};

export interface tb_QuestionType {
	questionTypeID: number;
	description: string;
};

export interface tb_RelationType {
	relationTypeID: number;
	description: string;
};

export interface tb_TermType {
	termTypeID: number;
	description: string;
};

export interface tb_User {
	userID: number;
	login: string;
	firstName: string;
	lastName: string;
	regionalCouncilCode?: string;
	password: string;
	eMail?: string;
	foneNumber?: string;
};

export interface tb_UserRole {
	userID: number;
	groupRoleID: number;
	hospitalUnitID: number;
	creationDate: string;
	expirationDate?: string;
};