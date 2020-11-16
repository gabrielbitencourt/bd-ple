import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { ICreateAnswer, IUpdateAnswer } from '../models/answer';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class AnswerService {

	constructor(private http: HttpClient) { }

	create(data: ICreateAnswer[]): Observable<IResponse> {
		return this.http.post<IResponse>(environment.apiUrl + `/answer`, data);
	}

	update(data: IUpdateAnswer): Observable<IResponse> {
		return this.http.put<IResponse>(environment.apiUrl + `/answer/${data.questionGroupFormRecordID}`, data);
	}

	updateMultiple(data: IUpdateAnswer[]): Observable<IResponse> {
		return this.http.put<IResponse>(environment.apiUrl + `/answer/multiple`, data);
	}

	delete(id: number): Observable<IResponse> {
		return this.http.delete<IResponse>(environment.apiUrl + `/answer/${id}`, {});
	}
}
