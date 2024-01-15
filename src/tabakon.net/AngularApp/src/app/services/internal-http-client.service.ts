import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpContext, HttpHeaders, HttpParams } from '@angular/common/http';
import { EnvironmentService } from './environment.service';

@Injectable({
  providedIn: 'root'
})
export class InternalHttpClient{

  constructor(
    private environmentService : EnvironmentService,
    private http : HttpClient
  ) { 

  }
  
  get<T>(url: string, options?: {
      headers?: HttpHeaders | {
          [header: string]: string | string[];
      };
      context?: HttpContext;
      observe?: 'body';
      params?: HttpParams | {
          [param: string]: string | number | boolean | ReadonlyArray<string | number | boolean>;
      };
      reportProgress?: boolean;
      responseType?: 'json';
      withCredentials?: boolean;
  }): Observable<T>{

    return this.http.get<T>(this.buildNewUrl(url), options);
  }


  post<T>(url: string, body: any | null, options?: {
      headers?: HttpHeaders | {
          [header: string]: string | string[];
      };
      context?: HttpContext;
      observe?: 'body';
      params?: HttpParams | {
          [param: string]: string | number | boolean | ReadonlyArray<string | number | boolean>;
      };
      reportProgress?: boolean;
      responseType?: 'json';
      withCredentials?: boolean;
  }): Observable<T>{

    return this.http.post<T>(this.buildNewUrl(url), body, options);
  }

  private buildNewUrl(url : string) : string {
    return this.environmentService.getBaseUrl() + url;
  }
}
