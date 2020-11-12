import { Route } from '@angular/compiler/src/core';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { first } from 'rxjs/operators';
import { IQuestionnaireAnswers } from 'src/app/models/questionnaire-answers';
import { FormRecordService } from 'src/app/services/form-record.service';
import { QuestionnaireService } from 'src/app/services/questionnaire.service';

interface ModuleTree {
	[formRecordID: string]: {
		module: any;
		groups: {
			[groupID: string]: {
				group: any;
				answers: IQuestionnaireAnswers[]
			}
		};
	};
}

@Component({
	selector: 'app-questionnaire',
	templateUrl: './questionnaire.component.html',
	styleUrls: ['./questionnaire.component.scss']
})
export class QuestionnaireComponent implements OnInit {

	modules: ModuleTree = {};

	constructor(private route: ActivatedRoute, private formRecordService: FormRecordService) { }

	async ngOnInit(): Promise<void> {
		const paramMap = await this.route.paramMap.pipe(first()).toPromise();
		const questionnaireID = paramMap.get('questionnaireID');
		const participantID = paramMap.get('participantID');
		const hospitalUnitID = paramMap.get('hospitalUnitID');
		const answers = await this.formRecordService.getAnswers(questionnaireID, hospitalUnitID, participantID)
			.pipe(first())
			.toPromise();

		this.modules = answers.reduce((prev, curr) => {
			if (!prev[curr.formRecordID]) {
				prev[curr.formRecordID] = {
					module: {
						id: curr.formRecordID,
						name: curr.crfDescription,
						data: curr.dtRegistroForm
					},
					groups: {}
				};
			}
			if (!prev[curr.formRecordID].groups[curr.questionGroupID]) {
				prev[curr.formRecordID].groups[curr.questionGroupID] = {
					group: {
						id: curr.questionGroupID,
						name: curr.questionGroupDescription
					},
					answers: []
				};
			}
			prev[curr.formRecordID].groups[curr.questionGroupID].answers.push(curr);
			return prev;
		}, {});
		console.log(this.modules);
	}

}
