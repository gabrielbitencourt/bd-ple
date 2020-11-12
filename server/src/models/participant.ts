import { ObjectModel } from "../database/object-model";

interface IParticipant {
	participantID: number;
	medicalRecord: string; // prontuário do paciente. 
};

class Participant extends ObjectModel<IParticipant> {
	constructor() {
		super({
			table: 'tb_Participant',
			fields: ['participantID', 'medicalRecord']
		});
	}
}

export const participant = new Participant();