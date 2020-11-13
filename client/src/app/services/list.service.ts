import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IListOption } from '../models/questionnaire-answers';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class ListService {

	constructor(private http: HttpClient) { }

	getListOptions(listID: string): Observable<IListOption[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/list/${listID}`, { withCredentials: true })
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}
}
