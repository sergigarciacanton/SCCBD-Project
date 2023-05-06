import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';

import * as rsa from 'rsa-module';
import * as bc from 'bigint-conversion';
import { RsaService } from 'src/app/service/rsa.service';

@Component({
  selector: 'app-encrypt-decrypt',
  templateUrl: './encrypt-decrypt.component.html',
  styleUrls: ['./encrypt-decrypt.component.css'],
})
export class EncryptDecryptComponent implements OnInit {
  encryptForm: FormGroup;
  decryptForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private toastr: ToastrService,
    private _rsaService: RsaService
  ) {
    this.encryptForm = this.fb.group({
      message: ['', Validators.required],
    });
    this.decryptForm = this.fb.group({
      ciphertext: ['', Validators.required],
    });
  }

  ngOnInit(): void {}

  encrypt() {
    const message: string = this.encryptForm.get('message')?.value;
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey = rsa.RsaPubKey.fromJSON(data);
        const ciphertext: bigint = serverPubKey.encrypt(
          bc.textToBigint(message)
        );
        this.decryptForm
          .get('ciphertext')
          ?.setValue(atob(bc.bigintToBase64(ciphertext)));
        //console.log(bc.bigintToBase64(ciphertext));
        this.toastr.success('Message encrypted!');
        this.encryptForm.reset();
      },
      (error) => {
        console.log(error);
        this.encryptForm.reset();
      }
    );
  }

  decrypt() {
    const ciphertext: string = btoa(this.decryptForm.get('ciphertext')?.value);
    this._rsaService
      .decrypt(rsa.JsonMessage.toJSON(bc.base64ToBigint(ciphertext)))
      .subscribe(
        (data) => {
          //console.log(bc.bigintToText(rsa.JsonMessage.fromJSON(data)));
          document
            .getElementById('resDecrypt')
            ?.setAttribute(
              'value',
              bc.bigintToText(rsa.JsonMessage.fromJSON(data))
            );
          this.toastr.success('Message decrypted!');
          this.decryptForm.reset();
        },
        (error) => {
          console.log(error);
          this.decryptForm.reset();
        }
      );
  }
}
