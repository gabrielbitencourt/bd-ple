import { Component, OnInit } from '@angular/core';
import { IUser } from 'src/app/models/user';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit {

  loggedIn = false;
  user: IUser;

  constructor(private authService: AuthService) { }

  ngOnInit(): void {
    this.authService.loggedIn.subscribe(l => this.loggedIn = l);
    this.authService.user.subscribe(u => this.user = u);
  }

}
