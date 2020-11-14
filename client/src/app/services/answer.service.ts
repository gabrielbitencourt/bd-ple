import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ICreateAnswer, IUpdateAnswer } from '../models/answer';

@Injectable({
	providedIn: 'root'
})
export class AnswerService {

	constructor(private http: HttpClient) { }

	create(data: ICreateAnswer[]): Observable<any> {
		return this.http.post(environment.apiUrl + `/answer`, data);
	}

	update(data: IUpdateAnswer): Observable<any> {
		return this.http.put(environment.apiUrl + `/answer/${data.questionGroupFormRecordID}`, data);
	}

	updateMultiple(data: IUpdateAnswer[]): Observable<any> {
		return this.http.put(environment.apiUrl + `/answer/multiple`, data);
	}
}
