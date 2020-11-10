export interface Question {
	questionID: number;
	description: string; // Descrição.
	questionTypeID: number; // Chave estrangeira para tabela tb_QuestionsTypes.
	listTypeID?: number;
	questionGroupID?: number;
	subordinateTo?: number;
	isAbout?: number;
};
