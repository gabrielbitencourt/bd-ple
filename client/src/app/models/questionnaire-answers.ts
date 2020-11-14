export interface IListOption {
	listOfValuesID: number;
	description: string;
}

export interface IQuestionnaireAnswers {
	questionGroupFormRecordID: number;
	formRecordID: number;
	dtRegistroForm: string;
	crfFormsID: number;
	crfDescription: string;
	answer: any;
	listValueID: number;
	listValueDescription: string;
	listTypeID: number;
	listTypeDescription: string;
	questionID: number;
	questionDescription: string;
	questionTypeID: number;
	questionTypeDescription: string;
	questionGroupID: number;
	questionGroupDescription: string;
	subordinateCount: number;
	options?: IListOption[];
	subordinates?: IQuestionnaireAnswers[];
}
