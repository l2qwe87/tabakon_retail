import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { InternalHttpClient } from '../services/internal-http-client.service';


//const IsmpCrptHost = "http://192.168.0.23:5000/"

@Injectable({
  providedIn: 'root'
})
export class MarkService {


  public getMarkInfo(mark : string) : Observable<any[]>{
    //return this.http.post<any[]>(IsmpCrptHost+"api/IsmpCrpt/Info", [mark]);
    return this.http.post<any[]>("/api/IsmpCrpt/Info", [mark]);
  }

  constructor(
    private http : InternalHttpClient
  ) { 

  }
}
