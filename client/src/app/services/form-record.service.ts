import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IQuestionnaireAnswersGroup, IQuestionnaireAnswers } from '../models/questionnaire-answers';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class FormRecordService {

	constructor(private http: HttpClient) { }

	getAnswersGroups(questionnaireId: number): Observable<IQuestionnaireAnswersGroup[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${questionnaireId}/groups`, { withCredentials: true })
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getAnswers(questionnaireId: string, hospitalId: string, participantId: string): Observable<IQuestionnaireAnswers[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/form-records/${questionnaireId}/participant/${participantId}/hospital/${hospitalId}`, { withCredentials: true })
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	create(questionnaireID: string, crfFormID: string, participantID: string, hospitalID: string): Observable<IResponse> {
		return this.http.post<IResponse>(environment.apiUrl + `/form-records/${questionnaireID}/crf/${crfFormID}/participant/${participantID}/hospital/${hospitalID}`, {}, { withCredentials: true });
	}
}
