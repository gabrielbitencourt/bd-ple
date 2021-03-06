import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { QuestionComponent } from './question.component';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { FormsModule } from '@angular/forms';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';

@NgModule({
	declarations: [
		QuestionComponent
	],
	imports: [
		CommonModule,
		MatFormFieldModule,
		MatInputModule,
		MatCheckboxModule,
		MatDatepickerModule,
		MatRadioModule,
		MatSelectModule,
		MatButtonModule,
		MatIconModule,
		MatMenuModule,
		FormsModule
	],
	exports: [
		QuestionComponent
	]
})
export class QuestionModule { }
