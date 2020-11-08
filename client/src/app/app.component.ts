import { Component, OnInit } from '@angular/core';
import { first } from 'rxjs/operators';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {

  constructor(private authService: AuthService) { }

  async ngOnInit(): Promise<void> {
    try {
      await this.authService.refreshToken().pipe(first()).toPromise();
    }
    catch (_) { }
  }

}
