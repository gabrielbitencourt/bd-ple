import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IAnswerHistory } from '../models/answer';
import { IFormRecord, IFormRecordDetail, IFormRecordGroup } from '../models/form-record';
import { IRespondantGroup } from '../models/questionnaire';
import { IQuestionnaireAnswers } from '../models/questionnaire-answers';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class FormRecordService {

	constructor(private http: HttpClient) { }

	create(questionnaireID: number, crfFormID: number, participantID: number, hospitalID: number): Observable<IResponse> {
		return this.http.post<IResponse>(environment.apiUrl + `/form-records/${questionnaireID}/crf/${crfFormID}/participant/${participantID}/hospital/${hospitalID}`, {});
	}

	getRespondantGroups(questionnaireID: number): Observable<IRespondantGroup[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/questionnaire/${questionnaireID}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getFormRecordsFromRespondant(questionnaireID: number, hospitalUnitID: number, participantID: number): Observable<IFormRecord[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/questionnaire/${questionnaireID}/hospital/${hospitalUnitID}/participant/${participantID}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getAnswersFromFormRecord(formRecordID: number): Observable<IFormRecordGroup[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${formRecordID}`)
			.pipe(
				map(res => {
					if (!res.error) return this.groupAnswers(res.data);
					return [];
				})
			);
	}

	groupAnswers(answers: IQuestionnaireAnswers[]): IFormRecordGroup[] {
		const groupsIndex = {};
		return answers.reduce((prev, curr) => {
			if (groupsIndex[curr.questionGroupID] === undefined) {
				const id = prev.push({
					id: curr.questionGroupID,
					name: curr.questionGroupDescription,
					answers: []
				});
				groupsIndex[curr.questionGroupID] = id - 1;
			}
			const groupIndex = groupsIndex[curr.questionGroupID];
			prev[groupIndex].answers.push(curr);
			return prev;
		}, []);
	}

	getAnswersFromParentQuestionInFormRecord(formRecordID: number, questionID: number): Observable<IQuestionnaireAnswers[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${formRecordID}/subordinate/${questionID}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getDetails(formRecordID: number): Observable<IFormRecordDetail> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${formRecordID}/details`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getHistory(formRecordID: number): Observable<IAnswerHistory[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${formRecordID}/history`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}
}
