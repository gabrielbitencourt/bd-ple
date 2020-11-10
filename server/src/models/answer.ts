// Tabela para registro da resposta associada a uma questão de um agrupamento de um formulário referente a um questionario de avaliação.\r
export interface Answer {
	questionGroupFormRecordID: number;
	formRecordID: number;
	crfFormsID: number;
	questionID: number;
	listOfValuesID?: number;
	answer?: string;
};
