import { Component, OnInit } from '@angular/core';
import * as rsa from 'rsa-module';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit {
  keys!: rsa.KeyPair;

  constructor() {
    this.generateKeys();
  }

  ngOnInit(): void {}

  private async generateKeys(): Promise<void> {
    this.keys = await rsa.generateKeyPair(2048);
    document
      .getElementById('pubKey')
      ?.setAttribute('value', this.keys.pubKey.toString());
    document
      .getElementById('privKey')
      ?.setAttribute('value', this.keys.privKey.toString());
  }
}
