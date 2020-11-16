import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AnswerComponent } from './answer/answer.component';
import { HistoryComponent } from './history/history.component';
import { QuestionnaireComponent } from './view/questionnaire.component';

const routes: Routes = [
	{
		path: ':questionnaireID/answers/:hospitalUnitID/:participantID',
		component: QuestionnaireComponent
	},
	{
		path: ':questionnaireID/answer',
		component: AnswerComponent
	},
	{
		path: ':formRecordID/history',
		component: HistoryComponent
	}
];

@NgModule({
	imports: [RouterModule.forChild(routes)],
	exports: [RouterModule]
})
export class QuestionnaireRoutingModule { }
