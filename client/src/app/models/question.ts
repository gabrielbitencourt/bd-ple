export interface IQuestion {
	questionID: number;
	description: string;
	questionTypeID: number;
	listTypeID?: number;
	questionGroupID: number;
	subordinateTo?: number;
	isAbout?: number;
}
