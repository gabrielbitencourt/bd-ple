import { Component, Input, OnInit } from '@angular/core';
import { IQuestionnaireAnswers } from 'src/app/models/questionnaire-answers';

@Component({
  selector: 'app-question',
  templateUrl: './question.component.html',
  styleUrls: ['./question.component.scss']
})
export class QuestionComponent implements OnInit {

  @Input() question: IQuestionnaireAnswers;

  constructor() { }

  ngOnInit(): void {
    console.log(this.question);
  }

}
