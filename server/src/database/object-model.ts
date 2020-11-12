import { ParsedRule } from 'indicative-parser';
import connection from '.';

type ValidationsMap = { [key: string]: { [key: string]: ParsedRule[]; }; };

export class ObjectModel<T> {
	table: string;
	fields: string[];
	validations: ValidationsMap = {};

	constructor({ table, fields, validations }: { table: string, fields: string[], validations?: ValidationsMap }) {
		this.table = table;
		this.fields = fields;
		if (validations) this.validations = validations;
	}

	async getAll(): Promise<T[]> {
		const data = await connection.asyncQuery(`SELECT * FROM ${this.table};`) as T[];
		return data;
	}

	async getById(id: string | string[]): Promise<T> {
		const data = await connection.asyncQuery(`SELECT * FROM ${this.table} WHERE ${this.fields[0]} = ${id};`) as T[];
		if (data.length) return data[0];
		throw new Error(`Entidade não encontrada na tabela ${this.table} com ${this.fields[0]} = ${id}.`);
	}

	async create(payload: T): Promise<void> {
		try {
			const writableFields = this.fields.slice(1);
			const payloadParams: any[] = writableFields.map(field => {
				return (payload as any)[field];
			});

			await connection.asyncQuery(`INSERT INTO ${this.table} (${writableFields.join(',')}) VALUES (${writableFields.map(_ => '?').join(',')});`, ...payloadParams);
		} catch (error) {
			throw error;	
		}
	}

	async delete(id: string): Promise<void> {
		try {
			await connection.asyncQuery(`DELETE FROM ${this.table} WHERE ${this.fields[0]};`, id);
		} catch (error) {
			throw error;
		}
	}
}