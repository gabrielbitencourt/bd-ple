import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IQuestionnaire } from '../models/questionnaire';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class QuestionnaireService {

	constructor(private http: HttpClient) { }

	getByID(id: number): Observable<IQuestionnaire> {
		return this.http.get<IResponse>(environment.apiUrl + `/questionnaire/${id}`).pipe(
			map(res => {
				if (!res.error) return res.data;
				return null;
			})
		);
	}

	getAll(): Observable<IQuestionnaire[]> {
		return this.http.get<IResponse>(environment.apiUrl + '/questionnaire').pipe(
			map(res => {
				if (!res.error) return res.data;
				return [];
			})
		);
	}

	create(data: IQuestionnaire): Observable<boolean> {
		return this.http.post<IResponse>(environment.apiUrl + '/questionnaire', data)
			.pipe(
				map(res => {
					return !res.error;
				})
			);
	}
}
