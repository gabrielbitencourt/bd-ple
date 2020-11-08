import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IResponse } from '../models/response';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  loggedIn = false;

  constructor(private http: HttpClient) { }

  refreshToken() {
    return this.http.get<IResponse>(environment.apiUrl + '/auth/refresh', { withCredentials: true })
      .pipe(
        tap(res => {
          this.loggedIn = !res.error;
        })
      );
  }

  login(credentials: { login: string, password: string }) {
    return this.http.post<IResponse>(environment.apiUrl + '/auth/login', credentials, { withCredentials: true })
      .pipe(
        tap(res => {
          this.loggedIn = !res.error;
        })
      );
  }
}
