import { Component, OnInit } from '@angular/core';
import { FormControl, Validators, FormGroup } from '@angular/forms';
import { MatExpansionPanel } from '@angular/material/expansion';
import { first } from 'rxjs/operators';
import { IQuestionnaire } from 'src/app/models/questionnaire';
import { QuestionnaireService } from 'src/app/services/questionnaire.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  questionnaires: IQuestionnaire[] = [];
  add = false;

  description = new FormControl('', [
    Validators.required,
    Validators.maxLength(255)
  ]);

  createForm = new FormGroup({
    description: this.description,
  });

  constructor(private questionnaireService: QuestionnaireService) { }

  ngOnInit(): void {
    this.loadQuestionnaires();
  }

  async loadQuestionnaires() {
    this.questionnaires = await this.questionnaireService.getAll().pipe(first()).toPromise();
  }

  async groupsFromQuestionnaire(questionnaire: IQuestionnaire) {
    if (!questionnaire.groups) {
      questionnaire.groups = await this.questionnaireService.getAnswersGroups(questionnaire.questionnaireID).pipe(first()).toPromise();
    }
  }

  async createQuestionnaire(panel: MatExpansionPanel) {
    const data: IQuestionnaire = { ...this.createForm.value };
    const created = await this.questionnaireService.create(data).pipe(first()).toPromise();
    if (created) {
      this.questionnaires.push(data);
      this.createForm.reset();
      panel.close();
    }
  }

}
