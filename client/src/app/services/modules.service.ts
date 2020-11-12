import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IModules } from '../models/modules';
import { IResponse } from '../models/response';

@Injectable({
  providedIn: 'root'
})
export class ModulesService {

  constructor(private http: HttpClient) { }

  getAll(questionnaireID: string): Observable<IModules[]> {
    return this.http.get<IResponse>(environment.apiUrl + `/crf/${questionnaireID}`, { withCredentials: true })
      .pipe(
        map(res => {
          if (!res.error) return res.data;
          return [];
        })
      );
  }
}
