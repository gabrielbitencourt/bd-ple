import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IListValue } from '../models/list-value';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class ListService {

	constructor(private http: HttpClient) { }

	getAllOptions(): Observable<{ [id: number]: IListValue }> {
		return this.http.get<IResponse>(environment.apiUrl + '/list').pipe(
			map(res => {
				if (!res.error) return this.groupByID(res.data);
				return [];
			})
		);
	}

	groupByID(arr: IListValue[]): { [id: number]: IListValue } {
		return arr.reduce((prev, curr) => {
			prev[curr.listOfValuesID] = curr;
			return prev;
		}, {});
	}

	getListOptions(listID: number): Observable<IListValue[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/list/${listID}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}
}
