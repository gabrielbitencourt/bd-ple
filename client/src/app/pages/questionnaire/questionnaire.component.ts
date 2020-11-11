import { Route } from '@angular/compiler/src/core';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { first } from 'rxjs/operators';
import { IQuestionnaireAnswers } from 'src/app/models/questionnaire-answers';
import { QuestionnaireService } from 'src/app/services/questionnaire.service';

@Component({
  selector: 'app-questionnaire',
  templateUrl: './questionnaire.component.html',
  styleUrls: ['./questionnaire.component.scss']
})
export class QuestionnaireComponent implements OnInit {

  answers: IQuestionnaireAnswers[] = [];

  constructor(private route: ActivatedRoute, private questionnaireService: QuestionnaireService) { }

  async ngOnInit(): Promise<void> {
    const paramMap = await this.route.paramMap.pipe(first()).toPromise();
    const questionnaireID = paramMap.get('questionnaireID');
    const participantID = paramMap.get('participantID');
    const hospitalUnitID = paramMap.get('hospitalUnitID');
    this.answers = await this.questionnaireService.getAnswers(questionnaireID, hospitalUnitID, participantID)
      .pipe(first())
      .toPromise();
  }

}
