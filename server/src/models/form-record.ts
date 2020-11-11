import { ObjectModel, Field } from '../database/object-model';
import { validator } from 'indicative';
const validations = validator.validations;

interface IFormRecord {
	formRecordID: number;
	participantID: number;
	hospitalUnitID: number;
	questionnaireID: number;
	crfFormsID: number;
	dtRegistroForm: string;
};

class FormRecord extends ObjectModel<IFormRecord> {
	constructor() {
		super({
			table: 'tb_FormRecord',
			fields: [
				Field.primary('formRecordID', true),
				Field.raw('dtRegistroForm'),
				Field.reference('participantID', 'tb_Participant', 'participantID'),
				Field.reference('hospitalUnitID', 'tb_HospitalUnit', 'hospitalUnitID'),
				Field.reference('questionnaireID', 'tb_Questionnaire', 'questionnaireID'),
				Field.reference('crfFormsID', '', 'crfFormsID')
			],
			validations: {
				insertValidation: {
					dtRegistroForm: [
						validations.required(),
						validations.dateFormat(['dd/MM/yyyy hh:mm:ss'])
					]
				},
				updateValidation: {
					dtRegistroForm: [
						validations.dateFormat(['dd/MM/yyyy hh:mm:ss'])
					]
				}
			}
		});
	}
}

export const formRecord = new FormRecord();