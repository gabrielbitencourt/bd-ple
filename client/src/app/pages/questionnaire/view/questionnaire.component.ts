import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { first } from 'rxjs/operators';
import { IHospital } from 'src/app/models/hospital';
import { IParticipant } from 'src/app/models/participant';
import { IQuestionnaire } from 'src/app/models/questionnaire';
import { IQuestionnaireAnswers } from 'src/app/models/questionnaire-answers';
import { FormRecordService } from 'src/app/services/form-record.service';
import { HospitalService } from 'src/app/services/hospital.service';
import { ParticipantService } from 'src/app/services/participant.service';
import { QuestionnaireService } from 'src/app/services/questionnaire.service';

type ModuleTree = {
	id: string;
	name: string;
	data: string;
	groups: {
		id: string;
		name: string;
		answers: IQuestionnaireAnswers[];
	}[];
};

@Component({
	selector: 'app-questionnaire',
	templateUrl: './questionnaire.component.html',
	styleUrls: ['./questionnaire.component.scss']
})
export class QuestionnaireComponent implements OnInit {

	modules: ModuleTree[] = [];
	questionnaire: IQuestionnaire;
	hospital: IHospital;
	participant: IParticipant;

	editMode = new BehaviorSubject<boolean>(false);

	constructor(
		private route: ActivatedRoute,
		private formRecordService: FormRecordService,
		private questionnaireService: QuestionnaireService,
		private hospitalService: HospitalService,
		private participantService: ParticipantService) { }

	async ngOnInit(): Promise<void> {
		const paramMap = await this.route.paramMap.pipe(first()).toPromise();
		const questionnaireID = paramMap.get('questionnaireID');
		const participantID = paramMap.get('participantID');
		const hospitalUnitID = paramMap.get('hospitalUnitID');
		const answers = await this.formRecordService.getAnswers(questionnaireID, hospitalUnitID, participantID)
			.pipe(first())
			.toPromise();

		this.questionnaireService.getByID(questionnaireID)
			.subscribe(q => {
				this.questionnaire = q;
			});

		this.hospitalService.getByID(hospitalUnitID)
			.subscribe(h => {
				this.hospital = h;
			});

		this.participantService.getByID(participantID)
			.subscribe(p => {
				this.participant = p;
			});

		const formsIndex = {};
		let groupsIndex = {};
		this.modules = answers.reduce((prev, curr) => {
			if (formsIndex[curr.formRecordID] === undefined) {
				groupsIndex = {};
				const id = prev.push({
					id: curr.formRecordID,
					name: curr.crfDescription,
					data: curr.dtRegistroForm,
					groups: []
				});
				formsIndex[curr.formRecordID] = id - 1;
			}
			const formIndex = formsIndex[curr.formRecordID];
			if (groupsIndex[curr.questionGroupID] === undefined) {
				const id = prev[formIndex].groups.push({
					id: curr.questionGroupID,
					name: curr.questionGroupDescription,
					answers: []
				});
				groupsIndex[curr.questionGroupID] = id - 1;
			}

			const groupIndex = groupsIndex[curr.questionGroupID];
			prev[formIndex].groups[groupIndex].answers.push(curr);
			return prev;
		}, []);
		console.log(this.modules);
	}

	edit() {
		this.editMode.next(!this.editMode.getValue());
	}

}
