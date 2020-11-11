import { ParsedRule } from 'indicative-parser';
import connection from '.';

type ValidationsMap = { [key: string]: { [key: string]: ParsedRule[]; }; };

enum FieldType { Raw, Reference, PrimaryKey };

export class Field {
	name: string;
	type: FieldType;

	refersToTable?: string;
	refersToField?: string;

	autoIncrement: boolean = false;

	constructor(name: string) {
		this.name = name;
		this.type = FieldType.Raw;
	}

	static raw(name: string): Field {
		const field = new Field(name);
		return field;
	}

	static reference(name: string, table: string, refField: string): Field {
		const field = new Field(name);
		field.type = FieldType.Reference;
		field.refersToTable = table;
		field.refersToField = refField;
		return field;
	}

	static primary(name: string, autoIncrement: boolean): Field {
		const field = new Field(name);
		field.type = FieldType.PrimaryKey;
		field.autoIncrement = autoIncrement;
		return field;
	}

	toString(): string {
		return this.name;
	}

}

export class ObjectModel<T> {
	table: string;
	primaryKey: Field;
	fields: Field[];
	validations: ValidationsMap = {};
	constructor({ table, fields, validations }: { table: string, fields: Field[], validations?: ValidationsMap }) {
		this.table = table;
		this.fields = fields;
		const primaries = fields.find(f => f.type == FieldType.PrimaryKey);
		if (primaries) this.primaryKey = primaries
		else throw new Error(`Nenhuma chave primária fornecida para o ObjectModel do ${this.table}.`);
		if (validations) this.validations = validations;
	}

	async getAll(fields?: string[]): Promise<T[]> {
		let selectFields = '*'
		if (fields) selectFields = fields.join(',');

		const data = await connection.asyncQuery(`SELECT ${selectFields} FROM ${this.table};`) as T[];
		return data;
	}

	async getById(id: string, fields?: string[]): Promise<T> {
		let selectFields = '*'
		if (fields) selectFields = fields.join(',');

		const data = await connection.asyncQuery(`SELECT ${selectFields} FROM ${this.table} WHERE ${this.primaryKey} = ${id};`) as T[];
		if (data.length) return data[0];
		throw new Error(`Entidade não encontrada na tabela ${this.table} com ${this.primaryKey} = ${id}.`);
	}

	async create(payload: T): Promise<void> {
		try {
			const writableFields = this.fields.filter(field => field.type != FieldType.PrimaryKey && !field.autoIncrement);
			const payloadParams: any[] = writableFields.map(field => {
				return (payload as any)[field.name];
			});

			await connection.asyncQuery(`INSERT INTO ${this.table} (${writableFields.join(',')}) VALUES (${writableFields.map(_ => '?').join(',')});`, ...payloadParams);
		} catch (error) {
			throw error;	
		}
	}

	async update(id: string, payload: T): Promise<void> {
		try {
			const writableFields = this.fields.filter(field => field.type != FieldType.PrimaryKey && !field.autoIncrement);
			const updateString: string[] = writableFields.map((field, index) => { return `${field} = ?`; });
			const payloadParams: any[] = writableFields.map(field => {
				return (payload as any)[field.name];
			});

			await connection.asyncQuery(`UPDATE ${this.table} SET ${updateString.join(',')} WHERE ${this.primaryKey} = ${id};`, ...payloadParams);
		} catch (error) {
			throw error;
		}
	}

	async delete(id: string): Promise<void> {
		try {
			await connection.asyncQuery(`DELETE FROM ${this.table} WHERE ${this.primaryKey} = ${id};`);
		} catch (error) {
			throw error;
		}
	}
}