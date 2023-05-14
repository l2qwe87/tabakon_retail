import { AfterViewInit, Component, Input, OnInit, ViewChild } from '@angular/core';
import { Observable, BehaviorSubject } from 'rxjs';
import { ICashierCheckInfo } from 'src/app/models/CashierCheck';
import { CashierCheckService } from 'src/app/services/cashier-check.service';
import { map } from 'rxjs/operators';
import { MatTableDataSource } from '@angular/material/table';
import { MatSort } from '@angular/material/sort';

@Component({
  selector: 'app-cashier-check-info-endpoint',
  templateUrl: './cashier-check-info-endpoint.component.html',
  styleUrls: ['./cashier-check-info-endpoint.component.scss']
})
export class CashierCheckInfoEndpointComponent implements OnInit, AfterViewInit {

  @Input()
  public retailEndpointIdentity : string;

  dataSource = new MatTableDataSource<ICashierCheckInfo>();
  $isLoading = new BehaviorSubject(true);

  @ViewChild(MatSort) matSort: MatSort;

  constructor(
    private cashierCheckService: CashierCheckService
  ) { }

  displayedColumns = ["date","sumSale","sumReturn","sumTerminal","sumCash"]

  data$: Observable<ICashierCheckInfo[]>;


  ngOnInit(): void {
    const days = 7;
    const dateFrom = new Date((new Date()).getTime() - (days * 1000 * 60 * 60 * 24));
    this.data$ = this.cashierCheckService.getInfoByRetailEndpointIdentity(this.retailEndpointIdentity, dateFrom.toJSON()).pipe(
      map(r => r.sort((a ,b) => (a.date > b.date ? -1 : 1))),
    );

    this.data$.subscribe(data => {
      this.dataSource.data = data;
      this.$isLoading.next(false);
    });
  }

  ngAfterViewInit() {
    this.dataSource.sort = this.matSort;
  }
    

}
