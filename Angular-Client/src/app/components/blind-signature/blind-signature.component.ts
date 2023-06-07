import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';

import * as rsa from 'rsa-module';
// @ts-ignore
import * as bcu from 'bigint-crypto-utils';
import * as bc from 'bigint-conversion';
import { RsaService } from 'src/app/service/rsa.service';

@Component({
  selector: 'app-blind-signature',
  templateUrl: './blind-signature.component.html',
  styleUrls: ['./blind-signature.component.css'],
})
export class BlindSignatureComponent implements OnInit {
  blindForm: FormGroup;
  signForm: FormGroup;
  unblindForm: FormGroup;
  verifyForm: FormGroup;

  r!: bigint;

  constructor(
    private fb: FormBuilder,
    private toastr: ToastrService,
    private _rsaService: RsaService
  ) {
    this.generateR();
    this.blindForm = this.fb.group({
      message: ['', Validators.required],
    });
    this.signForm = this.fb.group({
      blind_message: ['', Validators.required],
    });
    this.unblindForm = this.fb.group({
      signed_message: ['', Validators.required],
    });
    this.verifyForm = this.fb.group({
      unblind_message: ['', Validators.required],
    });
  }

  ngOnInit(): void {}

  private async generateR(): Promise<void> {
    this.r = await bcu.prime(Math.floor(2048) / 2);
  }

  blind() {
    const message: bigint = bc.textToBigint(
      this.blindForm.get('message')?.value
    );
    console.log('Message to blind: ', message);
    this._rsaService.getServerKey().subscribe(
      async (data) => {
        const serverPubKey: rsa.RsaPubKey = rsa.RsaPubKey.fromJSON(data);
        const blindMessage: bigint = bcu.modPow(
          message * bcu.modPow(this.r, serverPubKey.e, serverPubKey.n),
          1,
          serverPubKey.n
        );
        console.log('Blind message: ', blindMessage);
        this.signForm
          .get('blind_message')
          ?.setValue(bc.bigintToBase64(blindMessage));
        this.toastr.success('Message blind!');
        this.blindForm.reset();
      },
      (error) => {
        console.log(error);
        this.blindForm.reset();
      }
    );
  }

  sign() {
    const blindMessage: bigint = bc.base64ToBigint(
      this.signForm.get('blind_message')?.value
    );
    console.log('Ciphertext to sign: ', blindMessage);
    this._rsaService.sign(rsa.JsonMessage.toJSON(blindMessage)).subscribe(
      (data) => {
        const signed: bigint = rsa.JsonMessage.fromJSON(data);
        console.log('Signed message: ', signed);
        this.unblindForm
          .get('signed_message')
          ?.setValue(bc.bigintToBase64(signed));
        this.toastr.success('Message signed!');
        this.signForm.reset();
      },
      (error) => {
        console.log(error);
        this.signForm.reset();
      }
    );
  }

  unblind() {
    const signedMessage: bigint = bc.base64ToBigint(
      this.unblindForm.get('signed_message')?.value
    );
    console.log('Message to unblind: ', signedMessage);
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey: rsa.RsaPubKey = rsa.RsaPubKey.fromJSON(data);
        const unblindMessage: bigint = bcu.modPow(
          signedMessage * bcu.modInv(this.r, serverPubKey.n),
          1,
          serverPubKey.n
        );
        console.log('Unblinded message: ', unblindMessage);
        this.verifyForm
          .get('unblind_message')
          ?.setValue(bc.bigintToBase64(unblindMessage));
        this.toastr.success('Message unblinded!');
        this.unblindForm.reset();
      },
      (error) => {
        console.log(error);
        this.unblindForm.reset();
      }
    );
  }

  verify() {
    const ciphertext: bigint = bc.base64ToBigint(
      this.verifyForm.get('unblind_message')?.value
    );
    console.log('Ciphertext to verify: ', ciphertext);
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
