import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { RetailEndpoint } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoint-detail',
  templateUrl: './endpoint-detail.component.html',
  styleUrls: ['./endpoint-detail.component.scss']
})
export class EndpointDetailComponent implements OnInit, OnDestroy {

  
  constructor(
    private route: ActivatedRoute,
    private endpointsService : EndpointsService,
  ) { }

  retailEndpointIdentity : string = "";
  retailEndpoint : RetailEndpoint;

  ngOnInit(): void {
    let params = this.route.snapshot.params;
    if (params.retailEndpointIdentity){
      this.retailEndpointIdentity = params.retailEndpointIdentity;
    }

    this._subs.push(
      this.endpointsService.getEndpoints().subscribe( endpoints =>{
        let endpoint = endpoints.filter( e=> e.retailEndpointIdentity == this.retailEndpointIdentity)
        if(endpoint.length > 0)
          this.retailEndpoint = endpoint[0];
      })
    )
  }


  private _subs : Subscription[] = [];
  ngOnDestroy():void{ 
      this._subs.forEach( e => e.unsubscribe());
  }

}
