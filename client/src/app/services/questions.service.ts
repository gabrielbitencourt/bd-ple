import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IQuestion } from '../models/question';
import { IQuestionnaire } from '../models/questionnaire';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class QuestionsService {

	constructor(private http: HttpClient) { }
	getAll(): Observable<{ [id: number]: IQuestion }> {
		return this.http.get<IResponse>(environment.apiUrl + '/questions').pipe(
			map(res => {
				if (!res.error) return this.groupByID(res.data);
				return [];
			})
		);
	}

	groupByID(arr: IQuestion[]): { [id: number]: IQuestion } {
		return arr.reduce((prev, curr) => {
			prev[curr.questionID] = curr;
			return prev;
		}, {});
	}
}
