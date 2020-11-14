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
