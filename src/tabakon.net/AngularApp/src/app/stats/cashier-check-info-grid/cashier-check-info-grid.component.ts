import { Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { map, switchMap, withLatestFrom } from 'rxjs/operators';
import { ICashierCheckInfo } from 'src/app/models/CashierCheck';
import { CashierCheckService } from 'src/app/services/cashier-check.service';
import { EndpointsService } from 'src/app/services/endpoints.service';


interface ICashierCheckInfoExt extends ICashierCheckInfo{
  retailEndpointName: string;
}

@Component({
  selector: 'app-cashier-check-info-grid',
  templateUrl: './cashier-check-info-grid.component.html',
  styleUrls: ['./cashier-check-info-grid.component.scss']
})
export class CashierCheckInfoGridComponent implements OnInit {

  @Input()
  public date: Date;

  data$: Observable<ICashierCheckInfoExt[]>;

  constructor(
    private cashierCheckService: CashierCheckService,
    private endpointsService : EndpointsService
  ) { }

  ngOnInit(): void {
    this.data$ = this.cashierCheckService.getInfo(this.date).pipe(
      withLatestFrom(this.endpointsService.getEndpoints()),
      map(([info, endpoints])=>{
        return info.map(element => {
          let retailEndpointName = "";
          let endpoint = endpoints.filter(e => e.retailEndpointIdentity == element.retailEndpointIdentity);
          if(endpoint.length > 0){
            retailEndpointName = endpoint[0].retailEndpointName;
          };

          return {...element, retailEndpointName };
        });
        
      })
    );
  }


}
