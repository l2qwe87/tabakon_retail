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
import { RetailEndpoint, RetailVersion, RetailExtConfiguration, RetailEndpointExtData } from '../models/RetailEndpoint'

@Injectable({
  providedIn: 'root'
})
export class EndpointsService extends mixinHttp(class {},{ baseUrl: ""}){

  constructor() { 
    super();

    //this.getEndpointsVersionInternal().subscribe(v => this._retailVersion.next(v));
    //this.getEndpointsExtConfigurationInternal().subscribe(v => this._retailExtConfiguration.next(v));
  }

  //private _retailVersion = new BehaviorSubject<RetailVersion[]>([])
  //private _retailExtConfiguration = new BehaviorSubject<RetailExtConfiguration[]>([])

  @TdGET({
    path: '/api/RetailEndpoints',
  })
  getEndpoints(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailEndpoint[]> {
     return response.pipe(
       map(r => r as unknown as RetailEndpoint[])
     );
  }


  // getEndpointsVersion(): Observable<RetailVersion[]> {
  //   return this._retailVersion.asObservable();
  // }

  // getEndpointsExtConfiguration(): Observable<RetailExtConfiguration[]> {
  //   return this._retailExtConfiguration.asObservable();
  // }

  // @TdGET({
  //   path: '/api/RetailEndpointVersion',
  // })
  // private getEndpointsVersionInternal(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailVersion[]> {
  //    return response.pipe(
  //      map(r => r as unknown as RetailVersion[])
  //    );
  // }


  // @TdGET({
  //   path: '/api/RetailExtConfiguration',
  // })
  // private getEndpointsExtConfigurationInternal(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailExtConfiguration[]> {
  //    return response.pipe(
  //      map(r => r as unknown as RetailExtConfiguration[])
  //    );
  // }


}
