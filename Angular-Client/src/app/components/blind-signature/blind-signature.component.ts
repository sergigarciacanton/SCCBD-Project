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
    const message: string = this.blindForm.get('message')?.value;
    this._rsaService.getServerKey().subscribe(
      async (data) => {
        const serverPubKey = rsa.RsaPubKey.fromJSON(data);
        const blindMessage = bcu.modPow(
          bc.textToBigint(message) *
            bcu.modPow(this.r, serverPubKey.e, serverPubKey.n),
          1,
          serverPubKey.n
        );
        console.log(blindMessage);
        this.signForm
          .get('blind_message')
          ?.setValue(atob(bc.bigintToBase64(blindMessage)));
        //console.log(bc.bigintToText(bm));
        this.toastr.success('Message blinded!');
        this.blindForm.reset();
      },
      (error) => {
        console.log(error);
        this.blindForm.reset();
      }
    );
  }

  sign() {
    const blindMessage: string = btoa(
      this.signForm.get('blind_message')?.value
    );
    this._rsaService
      .sign(rsa.JsonMessage.toJSON(bc.base64ToBigint(blindMessage)))
      .subscribe(
        (data) => {
          //console.log(bc.bigintToBase64(rsa.JsonMessage.fromJSON(data)));
          this.unblindForm
            .get('signed_message')
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

  unblind() {
    const signedMessage: string = btoa(
      this.unblindForm.get('signed_message')?.value
    );
    this._rsaService.getServerKey().subscribe(
      (data) => {
        const serverPubKey = rsa.RsaPubKey.fromJSON(data);
        const unblindMessage = bcu.modPow(
          bc.base64ToBigint(signedMessage) * bcu.modInv(this.r, serverPubKey.n),
          1,
          serverPubKey.n
        );
        //console.log(bc.bigintToBase64(rsa.JsonMessage.fromJSON(data)));
        this.verifyForm
          .get('unblind_message')
          ?.setValue(atob(bc.bigintToBase64(unblindMessage)));
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
    const ciphertext: string = btoa(
      this.verifyForm.get('unblind_message')?.value
    );
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
