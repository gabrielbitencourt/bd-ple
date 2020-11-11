import { IQuestionnaireAnswersGroup } from './questionnaire-answers';

export interface IQuestionnaire {
    questionnaireID: number;
    description: string;
    groups: IQuestionnaireAnswersGroup[];
}
