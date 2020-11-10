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

  getAll(): Observable<IQuestionnaire[]> {
    return this.http.get<IResponse>(environment.apiUrl + '/questionnaire', { withCredentials: true }).pipe(
      map(res => {
        if (!res.error) return res.data as IQuestionnaire[];
        return [];
      })
    );
  }

  create(data: IQuestionnaire): Observable<boolean> {
    return this.http.post<IResponse>(environment.apiUrl + '/questionnaire', data, { withCredentials: true }).pipe(
      map(res => {
        return !res.error;
      })
    );
  }
}
