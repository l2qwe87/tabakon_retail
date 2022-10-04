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
import { ICashierCheckInfo } from '../models/CashierCheck'

@Injectable({
  providedIn: 'root'
})
export class CashierCheckService extends mixinHttp(class {},{ baseUrl: ""}){

  constructor() { 
    super();
  }

  @TdGET({
    path: '/api/CashierCheck/Total?date=:date',
  })
  getInfoTotal(
    @TdParam("date") date : Date, 
    @TdResponse() response?: Observable<HttpResponse<ICashierCheckInfo[]>>
  ): Observable<ICashierCheckInfo> {
     return response.pipe(
       map(r => r as unknown as ICashierCheckInfo[]),
       map(r => r.length == 1 ? r[0] : null)
     );
  }

  @TdGET({
    path: '/api/CashierCheck/Info?date=:date',
  })
  getInfo(
    @TdParam("date") date : Date, 
    @TdResponse() response?: Observable<HttpResponse<ICashierCheckInfo[]>>
  ): Observable<ICashierCheckInfo[]> {
     return response.pipe(
       map(r => r as unknown as ICashierCheckInfo[]),
     );
  }

  @TdGET({
    path: '/api/CashierCheck/:retailEndpointIdentity/Info',
  })
  getInfoByRetailEndpointIdentity(
    @TdParam('retailEndpointIdentity') retailEndpointIdentity : string, 
    @TdResponse() response?: Observable<HttpResponse<ICashierCheckInfo>>
  ): Observable<ICashierCheckInfo[]> {
     return response.pipe(
       map(r => r as unknown as ICashierCheckInfo[])
     );
  }
}
