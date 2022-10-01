import { Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { CashierCheckInfo } from 'src/app/models/CashierCheck';
import { CashierCheckService } from 'src/app/services/cashier-check.service';
import { map, catchError } from 'rxjs/operators';

@Component({
  selector: 'app-cashier-check-info-endpoint',
  templateUrl: './cashier-check-info-endpoint.component.html',
  styleUrls: ['./cashier-check-info-endpoint.component.scss']
})
export class CashierCheckInfoEndpointComponent implements OnInit {

  constructor(
    private cashierCheckService: CashierCheckService
  ) { }

  @Input()
  public retailEndpointIdentity : string;


  public data$: Observable<CashierCheckInfo[]>;

  ngOnInit(): void {
    this.data$ = this.cashierCheckService.getInfoByRetailEndpointIdentity(this.retailEndpointIdentity).pipe(
      map(r => r.sort((a ,b) => (a.date > b.data ? 1 : -1)))
    )
  }

}
