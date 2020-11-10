import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IResponse } from '../models/response';
import { IUser } from '../models/user';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  loggedIn = false;
  _user?: IUser;
  public get user(): IUser {
    return this._user;
  }

  public set user(v: IUser) {
    this._user = v;
  }


  constructor(private http: HttpClient) { }

  refreshToken() {
    return this.http.get<IResponse>(environment.apiUrl + '/auth/refresh', { withCredentials: true })
      .pipe(
        tap(res => {
          if (!res.error) {
            this.user = res.data;
          }
          this.loggedIn = !res.error;
        })
      );
  }

  login(credentials: { login: string, password: string }) {
    return this.http.post<IResponse>(environment.apiUrl + '/auth/login', credentials, { withCredentials: true })
      .pipe(
        tap(res => {
          if (!res.error) {
            this.user = res.data;
          }
          this.loggedIn = !res.error;
        })
      );
  }
}
