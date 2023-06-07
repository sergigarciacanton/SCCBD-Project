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
    const message: bigint = bc.textToBigint(
      this.signForm.get('message')?.value
    );
    console.log('Message to sign: ', message);
    this._rsaService.sign(rsa.JsonMessage.toJSON(message)).subscribe(
      (data) => {
        const signed: bigint = rsa.JsonMessage.fromJSON(data);
        console.log('Signed message: ', signed);
        this.verifyForm.get('ciphertext')?.setValue(bc.bigintToBase64(signed));
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
    const ciphertext: bigint = bc.base64ToBigint(
      this.verifyForm.get('ciphertext')?.value
    );
    console.log('Message to verify: ', ciphertext);
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey: rsa.RsaPubKey = rsa.RsaPubKey.fromJSON(data);
        const message: bigint = serverPubKey.verify(ciphertext);
        console.log('Verified message: ', message);
        document
          .getElementById('resVerify')
          ?.setAttribute('value', bc.bigintToText(message));
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
