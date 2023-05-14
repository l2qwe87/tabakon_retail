import { Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { ICashierCheckInfo } from 'src/app/models/CashierCheck';
import { CashierCheckService } from 'src/app/services/cashier-check.service';
import { map, catchError, tap } from 'rxjs/operators';
import { MatTableDataSource } from '@angular/material/table';

@Component({
  selector: 'app-cashier-check-info-endpoint',
  templateUrl: './cashier-check-info-endpoint.component.html',
  styleUrls: ['./cashier-check-info-endpoint.component.scss']
})
export class CashierCheckInfoEndpointComponent implements OnInit {

  dataSource = new MatTableDataSource<ICashierCheckInfo>();

  constructor(
    private cashierCheckService: CashierCheckService
  ) { }

  @Input()
  public retailEndpointIdentity : string;


  public data$: Observable<ICashierCheckInfo[]>;

  ngOnInit(): void {
    const days = 7;
    const dateFrom = new Date((new Date()).getTime() - (days * 1000 * 60 * 60 * 24));
    this.data$ = this.cashierCheckService.getInfoByRetailEndpointIdentity(this.retailEndpointIdentity, dateFrom.toJSON()).pipe(
      map(r => r.sort((a ,b) => (a.date > b.date ? -1 : 1))),
    );

    this.data$.subscribe(data => this.dataSource.data = data);
  }

}
