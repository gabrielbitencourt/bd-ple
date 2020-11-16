export interface IUpdateAnswer {
	questionGroupFormRecordID: number;
	answer: any;
	listOfValuesID: number;
}

export interface ICreateAnswer {
	formRecordID: number;
	crfFormsID: number;
	questionID: number;
	answer?: any;
	listOfValuesID?: number;
}

export interface IAnswerHistory {
	changedOn: string;
	operation: number;
	log: {
		answer: string;
		crfFormsID: number;
		formRecordID: number;
		listOfValuesID?: null;
		questionGroupFormRecordID: number;
		questionID: number;
	};
}
