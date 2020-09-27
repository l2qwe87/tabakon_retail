import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { filter, map } from 'rxjs/operators';
import { RetailEndpoint, RetailVersion } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoint-version',
  templateUrl: './endpoint-version.component.html',
  styleUrls: ['./endpoint-version.component.scss']
})
export class EndpointVersionComponent implements OnInit, OnDestroy {


  private _subs : Subscription[] = [];
  private _endpointIdentity : string;
  public retailVersion : RetailVersion;

  @Input()
  set endpoint(value : RetailEndpoint){
    if(value.retailEndpointIdentity != this._endpointIdentity){
      this._endpointIdentity = value.retailEndpointIdentity;
      
      let sub = this.endpointsService.getEndpointsVersion().pipe(
        map(v => {
          let filterResult = v.filter(e => e.retailEndpointIdentity == this._endpointIdentity)
          if(filterResult.length > 0){
            return filterResult[0];
          }else{
            return null;
          }
        }),
        filter(v => !!v)
      ).subscribe( v => this.retailVersion = v);

      this._subs.push(sub);
    }
  }

  constructor(
    private endpointsService : EndpointsService
  ) { 

  }

  ngOnInit(): void {
  }

  ngOnDestroy(): void {
    this._subs.forEach(s => s.unsubscribe());
  }

}
