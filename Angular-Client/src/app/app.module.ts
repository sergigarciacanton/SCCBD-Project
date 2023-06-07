import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToastrModule } from 'ngx-toastr';
import { HttpClientModule } from '@angular/common/http';

import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatNativeDateModule } from '@angular/material/core';
import { MatInputModule } from '@angular/material/input';

// Components
import { AppComponent } from './app.component';
import { EncryptDecryptComponent } from './components/encrypt-decrypt/encrypt-decrypt.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { SignVerifyComponent } from './components/sign-verify/sign-verify.component';
import { BlindSignatureComponent } from './components/blind-signature/blind-signature.component';
import { PaillierComponent } from './components/paillier/paillier.component';

@NgModule({
  declarations: [
    AppComponent,
    EncryptDecryptComponent,
    DashboardComponent,
    SignVerifyComponent,
    BlindSignatureComponent,
    PaillierComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot(),
    HttpClientModule,
    MatDatepickerModule,
    MatFormFieldModule,
    MatNativeDateModule,
    MatInputModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
