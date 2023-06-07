import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import * as paillier from 'paillier-module';
import * as bc from 'bigint-conversion';
import { PaillierService } from 'src/app/service/paillier.service';

@Component({
  selector: 'app-paillier',
  templateUrl: './paillier.component.html',
  styleUrls: ['./paillier.component.css'],
})
export class PaillierComponent implements OnInit {
  encryptForm: FormGroup;
  addForm: FormGroup;
  multiplyForm: FormGroup;
  decryptForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private toastr: ToastrService,
    private _paillierService: PaillierService
  ) {
    this.encryptForm = this.fb.group({
      message: ['', Validators.required],
    });
    this.addForm = this.fb.group({
      add_number: ['', Validators.required],
    });
    this.multiplyForm = this.fb.group({
      multiply_number: ['', Validators.required],
    });
    this.decryptForm = this.fb.group({
      encrypted_message: ['', Validators.required],
    });
  }

  ngOnInit(): void {}

  encrypt() {
    const message: bigint = BigInt(
      parseInt(this.encryptForm.get('message')?.value)
    );
    console.log('Message to encrypt: ', message);
    this._paillierService.getServerKey().subscribe(
      async (data) => {
        const serverPubKey: paillier.PaillierPubKey =
          paillier.PaillierPubKey.fromJSON(data);
        const encryptedMessage: bigint = serverPubKey.encrypt(message);
        console.log('Encrypted message: ', encryptedMessage);
        this.decryptForm
          .get('encrypted_message')
          ?.setValue(bc.bigintToBase64(encryptedMessage));
        this.toastr.success('Message encrypted!');
        this.encryptForm.reset();
      },
      (error) => {
        console.log(error);
        this.encryptForm.reset();
      }
    );
  }

  add() {
    const encryptedMessage: bigint = bc.base64ToBigint(
      this.decryptForm.get('encrypted_message')?.value
    );
    const addNum: bigint = BigInt(
      parseInt(this.addForm.get('add_number')?.value)
    );
    console.log('Ciphertext before adding: ', encryptedMessage);
    console.log('Number to add: ', addNum);
    this._paillierService.getServerKey().subscribe(
      (data) => {
        const serverPubKey: paillier.PaillierPubKey =
          paillier.PaillierPubKey.fromJSON(data);
        const added: bigint = serverPubKey.add(
          encryptedMessage,
          serverPubKey.encrypt(addNum)
        );
        console.log('Sum ciphertext: ', added);
        this.decryptForm
          .get('encrypted_message')
          ?.setValue(bc.bigintToBase64(added));
        this.toastr.success('Number added!');
        this.addForm.reset();
      },
      (error) => {
        console.log(error);
        this.addForm.reset();
      }
    );
  }

  multiply() {
    const encryptedMessage: bigint = bc.base64ToBigint(
      this.decryptForm.get('encrypted_message')?.value
    );
    const multiplyNum: bigint = BigInt(
      parseInt(this.multiplyForm.get('multiply_number')?.value)
    );
    console.log('Ciphertext before multiplying: ', encryptedMessage);
    console.log('Number to multiply: ', multiplyNum);
    this._paillierService.getServerKey().subscribe(
      (data) => {
        const serverPubKey: paillier.PaillierPubKey =
          paillier.PaillierPubKey.fromJSON(data);
        const multiplied: bigint = serverPubKey.multiply(
          encryptedMessage,
          multiplyNum
        );
        console.log('Product ciphertext: ', multiplied);
        this.decryptForm
          .get('encrypted_message')
          ?.setValue(bc.bigintToBase64(multiplied));
        this.toastr.success('Number multiplied!');
        this.multiplyForm.reset();
      },
      (error) => {
        console.log(error);
        this.multiplyForm.reset();
      }
    );
  }

  decrypt() {
    const ciphertext: bigint = bc.base64ToBigint(
      this.decryptForm.get('encrypted_message')?.value
    );
    console.log('Ciphertext to decrypt: ', ciphertext);
    this._paillierService
      .decrypt(paillier.JsonMessage.toJSON(ciphertext))
      .subscribe(
        (data) => {
          const decrypted: bigint = paillier.JsonMessage.fromJSON(data);
          console.log('Decrypted message: ', decrypted);
          document
            .getElementById('resDecrypt')
            ?.setAttribute('value', decrypted.toString());
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
