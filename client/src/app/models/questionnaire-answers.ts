export interface IListOption {
	listOfValuesID: string;
	description: string;
}

export interface IQuestionnaireAnswers {
	formRecordID: number;
	dtRegistroForm: string;
	crfDescription: string;
	answer: any;
	listValueID: string;
	listValueDescription: string;
	listTypeID: string;
	listTypeDescription: string;
	questionID: number;
	questionDescription: string;
	questionTypeID: number;
	questionTypeDescription: string;
	questionGroupID: number;
	questionGroupDescription: string;
	questaoPaiID: number;
	options?: IListOption[];
}

export interface IQuestionnaireAnswersGroup {
	participantID: number;
	medicalRecord: string;
	hospitalUnitName: string;
	hospitalUnitID: number;
	answers: IQuestionnaireAnswers[];
}
