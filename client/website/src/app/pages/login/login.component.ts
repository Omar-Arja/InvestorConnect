import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from './../../services/api.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  email: string = '';
  password: string = '';
  buttonText: String = 'Login';

  constructor(private router: Router, private apiService: ApiService) {}

  onSubmit(): void {
    this.buttonText = 'Loading...';

    this.apiService.login(this.email, this.password).subscribe((response) => {
      if (
        response.status === 'success' &&
        response.user.usertype_name === 'admin'
      ) {
        this.buttonText = 'Success';

        localStorage.setItem('token', response.authorisation.token);

        setTimeout(() => {
          this.router.navigate(['/dashboard']);
        }, 1000);
      } else {
        this.buttonText = 'Unauthorized';

        setTimeout(() => {
          this.buttonText = 'Login';
        }, 2000);
      }
    });
  }
}
