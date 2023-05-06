import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import * as rsa from 'rsa-module';

@Injectable({
  providedIn: 'root',
})
export class RsaService {
  url = 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  getServerKey(): Observable<rsa.RsaJsonPubKey> {
    return this.http.get<rsa.RsaJsonPubKey>(this.url + '/rsa/getPubKey');
  }

  decrypt(ciphertext: rsa.JsonMessage): Observable<rsa.JsonMessage> {
    return this.http.post<rsa.JsonMessage>(
      this.url + '/rsa/decrypt',
      ciphertext
    );
  }

  sign(message: rsa.JsonMessage): Observable<rsa.JsonMessage> {
    return this.http.post<rsa.JsonMessage>(this.url + '/rsa/sign', message);
  }
}
