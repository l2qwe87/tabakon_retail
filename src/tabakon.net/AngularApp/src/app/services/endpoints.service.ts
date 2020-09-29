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
import { RetailEndpoint, RetailVersion } from '../models/RetailEndpoint'

@Injectable({
  providedIn: 'root'
})
export class EndpointsService extends mixinHttp(class {},{ baseUrl: ""}){

  constructor() { 
    super();

    this.getEndpointsVersionInternal().subscribe(v => this._retailVersion.next(v));
  }

  private _retailVersion = new BehaviorSubject<RetailVersion[]>([])

  @TdGET({
    path: '/api/RetailEndpoints',
  })
  getEndpoints(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailEndpoint[]> {
     return response.pipe(
       map(r => r as unknown as RetailEndpoint[])
     );
  }


  getEndpointsVersion(): Observable<RetailVersion[]> {
    return this._retailVersion.asObservable();
  }

  @TdGET({
    path: '/api/RetailEndpointVersion',
  })
  private getEndpointsVersionInternal(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailVersion[]> {
     return response.pipe(
       map(r => r as unknown as RetailVersion[])
     );
  }


  // getEndpoints(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailEndpoint[]> {
  //   return response.pipe(
  //     map((data: any) => {
  //       return data as RetailEndpoint[];
  //     }),
  //   );
  // }
}
