import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { map, catchError } from 'rxjs/operators';

import {
  mixinHttp,
  TdGET,
  TdPOST,
  TdBody,
  TdParam,
  TdResponse,
  TdQueryParams,
} from '@covalent/http';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { CashierCheckInfo } from '../models/CashierCheck'

@Injectable({
  providedIn: 'root'
})
export class CashierCheckService extends mixinHttp(class {},{ baseUrl: ""}){

  constructor() { 
    super();
  }

  @TdGET({
    path: '/api/CashierCheck/:retailEndpointIdentity/Info',
  })
  getInfoByRetailEndpointIdentity(
    @TdParam('retailEndpointIdentity') retailEndpointIdentity : string, 
    @TdResponse() response?: Observable<HttpResponse<CashierCheckInfo>>
  ): Observable<any[]> {
     return response.pipe(
       map(r => r as unknown as CashierCheckInfo[])
     );
  }
}
