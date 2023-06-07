import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

// Components
import { EncryptDecryptComponent } from './components/encrypt-decrypt/encrypt-decrypt.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { SignVerifyComponent } from './components/sign-verify/sign-verify.component';
import { BlindSignatureComponent } from './components/blind-signature/blind-signature.component';
import { PaillierComponent } from './components/paillier/paillier.component';

// Routes
const routes: Routes = [
  { path: '', component: DashboardComponent },
  { path: 'encrypt-decrypt', component: EncryptDecryptComponent },
  { path: 'sign-verify', component: SignVerifyComponent },
  { path: 'blind-signature', component: BlindSignatureComponent },
  { path: 'paillier', component: PaillierComponent },
  { path: '**', redirectTo: '', pathMatch: 'full' }, // In case of a wrong URL, the code redirects to the main path
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
