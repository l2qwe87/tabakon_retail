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


  @Input()
  public retailVersion : RetailVersion;

  get isExpired() : boolean {
    let date1 = new Date( this.retailVersion.lastCheck);
    let date2 = new Date();
    let diff = Math.abs(date1.getTime() - date2.getTime());
    let diffHours = Math.ceil(diff / (1000 * 3600 )); 
    return diffHours > 2;    
  }

  constructor(
  ) { 

  }

  ngOnInit(): void {
  }

  ngOnDestroy(): void {
  }

}
