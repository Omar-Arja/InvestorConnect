import { Component } from '@angular/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  email: string = '';
  password: string = '';
  buttonText: String = 'Login';

  onSubmit(): void {
    console.log('submit', this.email, this.password);
  }
}
