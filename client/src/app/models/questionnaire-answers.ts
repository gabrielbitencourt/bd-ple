export interface IQuestionnaireAnswers {
    numeroPaciente: string;
    hospital: string;
    formRecordID: number;
    dataAplicacao: string;
    respostaLivre?: null;
    respostaLista?: string;
    nomeLista?: string;
    questionID: number;
    pergunta: string;
    questionTypeID: number;
    tipoPergunta: string;
    questionGroupID?: number;
    grupo?: string;
    questaoPai?: null;
}

export interface IQuestionnaireAnswersGroup {
    participantID: number;
    numeroPaciente: string;
    hospital: string;
    hospitalUnitID: number;
    answers: IQuestionnaireAnswers[];
}
