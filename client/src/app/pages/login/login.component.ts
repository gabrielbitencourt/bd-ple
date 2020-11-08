import { Component, OnInit } from '@angular/core';
import { FormControl, Validators, FormGroup } from '@angular/forms';
import { AuthService } from 'src/app/services/auth.service';
import { first } from 'rxjs/operators';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  hide = true;
  login = new FormControl('', [
    Validators.required
  ]);

  password = new FormControl('', [
    Validators.required
  ]);

  loginForm = new FormGroup({
    login: this.login,
    password: this.password
  });

  constructor(private authService: AuthService, private router: Router) { }

  ngOnInit(): void { }

  async onLogin(): Promise<void> {
    try {
      await this.authService
        .login({ ...this.loginForm.value })
        .pipe(first())
        .toPromise();
      this.router.navigate(['/']);
    }
    catch (error) {
      console.error(error);
    }
  }

}
