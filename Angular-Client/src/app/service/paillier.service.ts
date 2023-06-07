import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import * as paillier from 'paillier-module';

@Injectable({
  providedIn: 'root',
})
export class PaillierService {
  url = 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  getServerKey(): Observable<paillier.PaillierJsonPubKey> {
    return this.http.get<paillier.PaillierJsonPubKey>(
      this.url + '/paillier/getPubKey'
    );
  }

  decrypt(ciphertext: paillier.JsonMessage): Observable<paillier.JsonMessage> {
    return this.http.post<paillier.JsonMessage>(
      this.url + '/paillier/decrypt',
      ciphertext
    );
  }
}
