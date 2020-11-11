import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AlreadyLoggedInGuard } from './guards/already-logged-in.guard';
import { AuthGuard } from './guards/auth.guard';

const routes: Routes = [
  {
    path: '',
    canActivate: [AuthGuard],
    loadChildren: () => import('./pages/home/home.module').then(m => m.HomeModule)
  },
  {
    path: 'login',
    canActivate: [AlreadyLoggedInGuard],
    loadChildren: () => import('./pages/login/login.module').then(m => m.LoginModule)
  },
  {
    path: 'register',
    canActivate: [AlreadyLoggedInGuard],
    loadChildren: () => import('./pages/register/register.module').then(m => m.RegisterModule)
  },
  {
    path: 'questionnaire',
    canActivate: [AuthGuard],
    loadChildren: () => import('./pages/questionnaire/questionnaire.module').then(m => m.QuestionnaireModule)
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
