import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AnswerComponent } from './answer/answer.component';
import { QuestionnaireComponent } from './view/questionnaire.component';

const routes: Routes = [
  {
    path: ':questionnaireID/answers/:hospitalUnitID/:participantID',
    component: QuestionnaireComponent
  },
  {
    path: ':questionnaireID/answer',
    component: AnswerComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class QuestionnaireRoutingModule { }
