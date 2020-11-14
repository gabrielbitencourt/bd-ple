export interface IQuestionnaire {
	questionnaireID: number;
	description: string;
	groups: IRespondantGroup[];
}

export interface IRespondantGroup {
	formRecordID: number;
	participantID: number;
	medicalRecord: string;
	hospitalUnitID: number;
	hospitalUnitName: string;
}
