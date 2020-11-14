import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IHospital } from '../models/hospital';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class HospitalService {

	constructor(private http: HttpClient) { }

	getByID(id: number): Observable<IHospital> {
		return this.http.get<IResponse>(environment.apiUrl + `/hospital/${id}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getAll(): Observable<IHospital[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/hospital`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}
}
