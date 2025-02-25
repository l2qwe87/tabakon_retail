import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';

import { HttpClient, } from '@angular/common/http';
import { ICashierCheckInfo } from '../models/CashierCheck'

@Injectable({
  providedIn: 'root'
})
export class CashierCheckService {

  constructor(
    private http : HttpClient
  ) {
  }

  getInfoTotal(date : string):Observable<ICashierCheckInfo> {
    return this.http.get<ICashierCheckInfo>(`/api/CashierCheck/Total?date=${date}`).pipe(
      map(data => data[0])
    );
  }

  getInfo(date : string):Observable<ICashierCheckInfo[]> {
    return this.http.get<ICashierCheckInfo[]>(`/api/CashierCheck/Info?date=${date}`);
  }
  
  getInfoByRetailEndpointIdentity(retailEndpointIdentity : string,dateFrom : string):Observable<ICashierCheckInfo[]>{
    return this.http.get<ICashierCheckInfo[]>(`/api/CashierCheck/${retailEndpointIdentity}/Info?dateFrom=${dateFrom}`);
  }
}
