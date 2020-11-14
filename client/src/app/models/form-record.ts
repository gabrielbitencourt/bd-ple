import { IQuestionnaireAnswers } from './questionnaire-answers';

export interface IModules {
	crfFormsID: number;
	questionnaireID: number;
	description: string;
}

export interface IFormRecord {
	formRecordID: number;
	dtRegistroForm: string;
	descriptions: string;
	crfFormsID: number;
	groups?: IFormRecordGroup[];
}

export interface IFormRecordGroup {
	id: number;
	name: string;
	answers: IQuestionnaireAnswers[];
}
