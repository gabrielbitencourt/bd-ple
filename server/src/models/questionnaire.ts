import { ObjectModel, Field } from '../database/object-model';
import { validator } from 'indicative';
const validations = validator.validations;

interface IQuestionnaire {
	questionnaireID: number;
	description: string;
};

class Questionnaire extends ObjectModel<IQuestionnaire> {
	constructor() {
		super({
			table: 'tb_Questionnaire',
			fields: [Field.primary('questionnaireID', true), Field.raw('description')],
			validations: {
				insertValidation: {
					description: [
						validations.required(),
						validations.string(),
						validations.max([255])
					]
				},
				updateValidation: {
					description: [
						validations.string(),
						validations.max([255])
					]
				}
			}
		});
	}
};

export const questionnaire = new Questionnaire();