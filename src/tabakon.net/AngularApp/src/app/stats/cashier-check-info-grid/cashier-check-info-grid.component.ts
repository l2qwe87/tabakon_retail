import { Component, Input, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material/table';
import { BehaviorSubject, Observable } from 'rxjs';
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

  //sortBy: string = 'retailEndpointName';
  //sortOrder: TdDataTableSortingOrder = TdDataTableSortingOrder.Ascending;

  data$: Observable<ICashierCheckInfoExt[]>;

  update$: BehaviorSubject<any>= new BehaviorSubject<any>(true);

  dataSource = new MatTableDataSource<ICashierCheckInfoExt>();

  constructor(
    private cashierCheckService: CashierCheckService,
    private endpointsService : EndpointsService
  ) { }

  ngOnInit(): void {
    this.data$ = this.update$.pipe(
      switchMap( _ =>  this.cashierCheckService.getInfo((this.date instanceof Date ? this.date.toJSON() : this.date))),
      withLatestFrom(this.endpointsService.getEndpoints()),
      map(([info, endpoints])=>{
        let data = info.map(element => {
          let retailEndpointName = "";
          let endpoint = endpoints.filter(e => e.retailEndpointIdentity == element.retailEndpointIdentity);
          if(endpoint.length > 0){
            retailEndpointName = endpoint[0].retailEndpointName;
          };

          return {...element, retailEndpointName };
        });
        
        // data.sort((a:ICashierCheckInfoExt, b:ICashierCheckInfoExt) => {
        //   let direction: number = 0;
        //   if (this.sortOrder === TdDataTableSortingOrder.Descending) {
        //     direction = 1;
        //   } else if (this.sortOrder === TdDataTableSortingOrder.Ascending) {
        //     direction = -1;
        //   }

        //   let leftValue = a[this.sortBy];
        //   let rightValue = b[this.sortBy];
        //   if (leftValue < rightValue) {
        //     return direction;
        //   } else if (leftValue > rightValue) {
        //     return -direction;
        //   } else {
        //     return direction;
        //   }
        // });
        return data;
      })
    );

    this.data$.subscribe( data => {
      this.dataSource.data = data;
    })
  }

  // sort(sortEvent: ITdDataTableSortChangeEvent): void {
  //   this.sortOrder =
  //     this.sortOrder === TdDataTableSortingOrder.Ascending
  //       ? TdDataTableSortingOrder.Descending
  //       : TdDataTableSortingOrder.Ascending;
  //   this.sortBy = sortEvent.name;

  //   this.update$.next();
  // }
}

