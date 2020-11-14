import { Component, OnInit } from '@angular/core';
import { MatExpansionPanel } from '@angular/material/expansion';
import { ActivatedRoute } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { first } from 'rxjs/operators';
import { ICreateAnswer, IUpdateAnswer } from 'src/app/models/answer';
import { IFormRecord } from 'src/app/models/form-record';
import { IHospital } from 'src/app/models/hospital';
import { IParticipant } from 'src/app/models/participant';
import { IQuestionnaire } from 'src/app/models/questionnaire';
import { AnswerService } from 'src/app/services/answer.service';
import { FormRecordService } from 'src/app/services/form-record.service';
import { HospitalService } from 'src/app/services/hospital.service';
import { ParticipantService } from 'src/app/services/participant.service';
import { QuestionnaireService } from 'src/app/services/questionnaire.service';

@Component({
	selector: 'app-questionnaire',
	templateUrl: './questionnaire.component.html',
	styleUrls: ['./questionnaire.component.scss']
})
export class QuestionnaireComponent implements OnInit {

	formRecordsPreEdit: IFormRecord[] = [];
	formRecords: IFormRecord[] = [];
	questionnaire: IQuestionnaire;
	hospital: IHospital;
	participant: IParticipant;

	editMode = new BehaviorSubject<boolean>(false);

	constructor(
		private route: ActivatedRoute,
		private formRecordService: FormRecordService,
		private questionnaireService: QuestionnaireService,
		private hospitalService: HospitalService,
		private answerService: AnswerService,
		private participantService: ParticipantService) { }

	async ngOnInit(): Promise<void> {
		const paramMap = await this.route.paramMap.pipe(first()).toPromise();
		const questionnaireID = parseInt(paramMap.get('questionnaireID'), 10);
		const hospitalUnitID = parseInt(paramMap.get('hospitalUnitID'), 10);
		const participantID = parseInt(paramMap.get('participantID'), 10);

		this.formRecords = await this.formRecordService.getFormRecordsFromRespondant(questionnaireID, hospitalUnitID, participantID)
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
	}

	async groupsFromFormRecord(formRecord: IFormRecord): Promise<void> {
		if (!formRecord.groups) {
			formRecord.groups = await this.formRecordService.getAnswersFromFormRecord(formRecord.formRecordID)
				.pipe(first())
				.toPromise();
		}
	}

	newFormRecord(data: IFormRecord, panel: MatExpansionPanel): void {
		this.formRecords.push(data);
		panel.close();
	}

	closedFormRecord(index: number): void {
		if (this.editMode.getValue() === true &&
			confirm('Fechar os dados irá descartar todas as alterações. Tem certeza que deseja continuar?')) {
			this.cancel(index);
		}
	}

	async edit(moduleIndex: number): Promise<void> {
		if (this.editMode.getValue() === true) {
			this.editMode.next(false);
			const toInsert: ICreateAnswer[] = [];
			const toUpdate: IUpdateAnswer[] = [];
			for (const [groupIndex, group] of this.formRecords[moduleIndex].groups.entries()) {
				for (const [index, question] of group.answers.entries()) {
					const oldQuestion = this.formRecordsPreEdit[moduleIndex].groups[groupIndex].answers[index];
					if (question.answer === '') question.answer = null;
					if (question.answer !== oldQuestion.answer || question.listValueID !== oldQuestion.listValueID) {
						if (question.questionGroupFormRecordID) {
							toUpdate.push({
								questionGroupFormRecordID: question.questionGroupFormRecordID,
								answer: question.answer !== undefined && question.answer !== null ? question.answer : undefined,
								listOfValuesID: question.listValueID !== undefined && question.listValueID !== null ? question.listValueID : undefined
							});
						}
						else {
							toInsert.push({
								formRecordID: question.formRecordID,
								crfFormsID: question.crfFormsID,
								questionID: question.questionID,
								answer: question.answer !== undefined && question.answer !== null ? question.answer : undefined,
								listOfValuesID: question.listValueID !== undefined && question.listValueID !== null ? question.listValueID : undefined
							});
						}
					}
					if (question.subordinates) {
						for (const [subIndex, subordinate] of question.subordinates.entries()) {
							const oldSubordinate = oldQuestion.subordinates[subIndex];
							if (subordinate.answer === '') subordinate.answer = null;
							if (subordinate.answer !== oldSubordinate.answer || subordinate.listValueID !== oldSubordinate.listValueID) {
								if (subordinate.questionGroupFormRecordID) {
									toUpdate.push({
										questionGroupFormRecordID: subordinate.questionGroupFormRecordID,
										answer: subordinate.answer !== undefined && subordinate.answer !== null ? subordinate.answer : undefined,
										listOfValuesID: subordinate.listValueID !== undefined && subordinate.listValueID !== null ? subordinate.listValueID : undefined
									});
								}
								else {
									toInsert.push({
										formRecordID: subordinate.formRecordID,
										crfFormsID: subordinate.crfFormsID,
										questionID: subordinate.questionID,
										answer: subordinate.answer !== undefined && subordinate.answer !== null ? subordinate.answer : undefined,
										listOfValuesID: subordinate.listValueID !== undefined && subordinate.listValueID !== null ? subordinate.listValueID : undefined
									});
								}
							}
						}
					}
				}
			}
			console.log(toInsert, toUpdate);
			try {
				if (toInsert.length) {
					await this.answerService.create(toInsert).pipe(first()).toPromise();
				}

				if (toUpdate.length > 1) {
					await this.answerService.updateMultiple(toUpdate).pipe(first()).toPromise();
				}
				else if (toUpdate.length === 1) {
					await this.answerService.update(toUpdate[0]).pipe(first()).toPromise();
				}

			} catch (error) {
				this.cancel(moduleIndex);
			}
		}
		else {
			this.editMode.next(true);
			this.formRecordsPreEdit = JSON.parse(JSON.stringify(this.formRecords));
		}
	}

	cancel(index: number): void {
		this.formRecords[index] = this.formRecordsPreEdit[index];
		this.editMode.next(false);
	}

}
