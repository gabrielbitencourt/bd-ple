import { ObjectModel } from "../database/object-model";

interface IHospital {
	hospitalUnitID: number;
	hospitalUnitName: string;
};

class Hospital extends ObjectModel<IHospital> {
	constructor() {
		super({
			table: 'tb_HospitalUnit',
			fields: ['hospitalUnitID', 'hospitalUnitName']
		});
	}
}

export const hospital = new Hospital();