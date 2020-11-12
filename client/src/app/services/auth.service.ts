import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IResponse } from '../models/response';
import { IUser } from '../models/user';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  loggedIn: BehaviorSubject<boolean> = new BehaviorSubject(false);
  user: BehaviorSubject<IUser> = new BehaviorSubject(null);


  constructor(private http: HttpClient) {
    this.loggedIn.next(false);
  }

  refreshToken() {
    return this.http.get<IResponse>(environment.apiUrl + '/auth/refresh', { withCredentials: true })
      .pipe(
        tap(res => {
          if (!res.error) {
            this.user.next(res.data);
          }
          this.loggedIn.next(!res.error);
        })
      );
  }

  login(credentials: { login: string, password: string }) {
    return this.http.post<IResponse>(environment.apiUrl + '/auth/login', credentials, { withCredentials: true })
      .pipe(
        tap(res => {
          if (!res.error) {
            this.user.next(res.data);
          }
          this.loggedIn.next(!res.error);
        })
      );
  }
}
