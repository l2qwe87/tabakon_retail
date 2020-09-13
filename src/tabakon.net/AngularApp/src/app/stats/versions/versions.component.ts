import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RetailEndpoint } from '../../models/RetailEndpoint';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators'

@Component({
  selector: 'app-versions',
  templateUrl: './versions.component.html',
  styleUrls: ['./versions.component.scss']
})
export class VersionsComponent implements OnInit {


  public dataSet : RetailEndpoint[];
  public columns : any[] = [//ITdDataTableColumn[] =[
    { name : 'RetailEndpointName', label : 'Retail Endpoint Name'}
  ]

  constructor(
    private http : HttpClient
  ) { }

  ngOnInit(): void {
    console.log("qqq");
    this.refreshData();
  }


  private refreshData(){
    this.http.get<RetailEndpoint[]>("api/RetailEndpoints").pipe(
      tap(e => console.log(e))
    ).subscribe(r => this.dataSet = r)
  }


}
 