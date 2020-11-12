export interface IQuestionnaireAnswers {
    formRecordID: number;
    dtRegistroForm: string;
    crfDescription: string;
    answer: string;
    listValueDescription: string;
    listTypeDescription: string;
    questionID: number;
    questionDescription: string;
    questionTypeID: number;
    questionTypeDescription: string;
    questionGroupID: number;
    questionGroupDescription: string;
    questaoPaiID: number;
}

export interface IQuestionnaireAnswersGroup {
    participantID: number;
    medicalRecord: string;
    hospitalUnitName: string;
    hospitalUnitID: number;
    answers: IQuestionnaireAnswers[];
}
