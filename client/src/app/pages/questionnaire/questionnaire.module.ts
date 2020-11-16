import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { QuestionnaireRoutingModule } from './questionnaire-routing.module';
import { QuestionnaireComponent } from './view/questionnaire.component';
import { AnswerComponent } from './answer/answer.component';
import { ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatExpansionModule } from '@angular/material/expansion';
import { QuestionModule } from 'src/app/components/question/question.module';
import { MatTooltipModule } from '@angular/material/tooltip';
import { HistoryComponent } from './history/history.component';
import { MatDividerModule } from '@angular/material/divider';

@NgModule({
	declarations: [
		QuestionnaireComponent,
		AnswerComponent,
		HistoryComponent
	],
	imports: [
		CommonModule,
		QuestionnaireRoutingModule,
		ReactiveFormsModule,
		MatInputModule,
		MatFormFieldModule,
		MatButtonModule,
		MatIconModule,
		MatListModule,
		MatExpansionModule,
		MatTooltipModule,
		MatDividerModule,
		QuestionModule
	]
})
export class QuestionnaireModule { }
