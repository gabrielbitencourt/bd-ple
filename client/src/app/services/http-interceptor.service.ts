import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
	providedIn: 'root'
})
export class HttpInterceptorService implements HttpInterceptor {
	constructor(private router: Router) { }
	intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
		const request = req.clone({
			withCredentials: true
		});
		return next.handle(request).pipe(
			catchError(err => {
				if (err instanceof HttpErrorResponse) {
					if (err.status === 401) {
						this.router.navigateByUrl('/login');
					}
				}
				return of(err);
			})
		);
	}
}
