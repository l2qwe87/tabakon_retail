import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
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
import { RetailEndpoint } from '../models/RetailEndpoint'

@Injectable({
  providedIn: 'root'
})
export class EndpointsService extends mixinHttp(class {},{ baseUrl: ""}){

  constructor() { 
    super();
  }

  @TdGET({
    path: '/api/RetailEndpoints',
  })
  getEndpoints(@TdResponse() response?: Observable<HttpResponse<any>>): Observable<RetailEndpoint[]> {
     return response.pipe(
       map(r => r as unknown as RetailEndpoint[])
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
