import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IParticipant } from '../models/participant';
import { IResponse } from '../models/response';

@Injectable({
	providedIn: 'root'
})
export class ParticipantService {

	constructor(private http: HttpClient) { }

	getByID(id: number): Observable<IParticipant> {
		return this.http.get<IResponse>(environment.apiUrl + `/participant/${id}`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}

	getAll(): Observable<IParticipant[]> {
		return this.http.get<IResponse>(environment.apiUrl + `/participant`)
			.pipe(
				map(res => {
					if (!res.error) return res.data;
					return [];
				})
			);
	}
}
