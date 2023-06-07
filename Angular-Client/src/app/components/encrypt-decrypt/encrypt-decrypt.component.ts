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
    const message: bigint = bc.textToBigint(
      this.encryptForm.get('message')?.value
    );
    console.log('Message to encrypt: ', message);
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey: rsa.RsaPubKey = rsa.RsaPubKey.fromJSON(data);
        const ciphertext: bigint = serverPubKey.encrypt(message);
        console.log('Encrypted message: ', ciphertext);
        this.decryptForm
          .get('ciphertext')
          ?.setValue(bc.bigintToBase64(ciphertext));
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
    const ciphertext: bigint = bc.base64ToBigint(
      this.decryptForm.get('ciphertext')?.value
    );
    console.log('Ciphertext to decrypt: ', ciphertext);
    this._rsaService.decrypt(rsa.JsonMessage.toJSON(ciphertext)).subscribe(
      (data) => {
        const decrypted: bigint = rsa.JsonMessage.fromJSON(data);
        console.log('Decrypted message: ', decrypted);
        document
          .getElementById('resDecrypt')
          ?.setAttribute('value', bc.bigintToText(decrypted));
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
