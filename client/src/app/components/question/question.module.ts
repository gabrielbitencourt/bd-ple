import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { QuestionComponent } from './question.component';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';

@NgModule({
  declarations: [
    QuestionComponent
  ],
  imports: [
    CommonModule,
    MatFormFieldModule,
    MatInputModule
  ],
  exports: [
    QuestionComponent
  ]
})
export class QuestionModule { }
