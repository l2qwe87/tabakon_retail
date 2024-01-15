import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { RetailEndpoint, RetailVersion, RetailExtConfiguration } from '../models/RetailEndpoint'
import { InternalHttpClient } from './internal-http-client.service';

@Injectable({
  providedIn: 'root'
})
export class EndpointsService{

  constructor(
    private http : InternalHttpClient
  ) { 

  }

  getEndpoints(): Observable<RetailEndpoint[]> {
    return this.http.get<RetailEndpoint[]>("/api/RetailEndpoints");
  }

  updateData(retailEndpointIdentity: string):Observable<RetailVersion> {
    return this.http.get<RetailVersion>(`/api/RetailEndpoints/UpdateData/${retailEndpointIdentity}`);
  }

  getRetailVersion(retailEndpointIdentity: string): Observable<RetailVersion>{
    return this.http.get<RetailVersion>(`/api/RetailEndpoints/RetailVersion/${retailEndpointIdentity}`);
  }

  getRetailExtConfiguration(retailEndpointIdentity: string): Observable<RetailExtConfiguration> {
    return this.http.get<RetailExtConfiguration>(`/api/RetailEndpoints/RetailExtConfiguration/${retailEndpointIdentity}`);
  }

  setRetailExtConfiguration(retailEndpointIdentity : string, extConfiguration : string): Observable<RetailExtConfiguration>{
    return this.http.get<RetailExtConfiguration>(`/api/RetailEndpoints/RetailExtConfiguration/${retailEndpointIdentity}/${extConfiguration}`);
  }

  run_apply_cfe(retailEndpointIdentity : string): Observable<any>{
    return this.http.get<RetailExtConfiguration>(`/api/RetailEndpoints/Run_apply_cfe/${retailEndpointIdentity}`);
  }

  run_exRetailOle(retailEndpointIdentity : string){
    return this.http.get<RetailExtConfiguration>(`/api/RetailEndpoints/Run_exRetailOle/${retailEndpointIdentity}`);
  }
}
