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

  getAll(): Observable<IHospital[]> {
    return this.http.get<IResponse>(environment.apiUrl + `/hospital`, { withCredentials: true })
      .pipe(
        map(res => {
          if (!res.error) return res.data;
          return [];
        })
      );
  }
}
