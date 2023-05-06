import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { Validators } from '@angular/forms';
import { FormBuilder, FormGroup } from '@angular/forms';

import * as rsa from 'rsa-module';
import * as bc from 'bigint-conversion';
import { RsaService } from 'src/app/service/rsa.service';

@Component({
  selector: 'app-sign-verify',
  templateUrl: './sign-verify.component.html',
  styleUrls: ['./sign-verify.component.css'],
})
export class SignVerifyComponent implements OnInit {
  signForm: FormGroup;
  verifyForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private toastr: ToastrService,
    private _rsaService: RsaService
  ) {
    this.signForm = this.fb.group({
      message: ['', Validators.required],
    });
    this.verifyForm = this.fb.group({
      ciphertext: ['', Validators.required],
    });
  }

  ngOnInit(): void {}

  sign() {
    const message: string = this.signForm.get('message')?.value;
    this._rsaService
      .sign(rsa.JsonMessage.toJSON(bc.textToBigint(message)))
      .subscribe(
        (data) => {
          //console.log(bc.bigintToBase64(rsa.JsonMessage.fromJSON(data)));
          this.verifyForm
            .get('ciphertext')
            ?.setValue(atob(bc.bigintToBase64(rsa.JsonMessage.fromJSON(data))));
          this.toastr.success('Message signed!');
          this.signForm.reset();
        },
        (error) => {
          console.log(error);
          this.signForm.reset();
        }
      );
  }

  verify() {
    const ciphertext: string = btoa(this.verifyForm.get('ciphertext')?.value);
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey = rsa.RsaPubKey.fromJSON(data);
        const message: bigint = serverPubKey.verify(
          bc.base64ToBigint(ciphertext)
        );
        document
          .getElementById('resVerify')
          ?.setAttribute('value', bc.bigintToText(message));
        //console.log(bc.bigintToText(message));
        this.toastr.success('Message encrypted!');
        this.verifyForm.reset();
      },
      (error) => {
        console.log(error);
        this.verifyForm.reset();
      }
    );
  }
}
