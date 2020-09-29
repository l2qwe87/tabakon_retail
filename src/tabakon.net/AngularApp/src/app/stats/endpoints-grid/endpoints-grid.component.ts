import { Component, OnInit } from '@angular/core';
import { ITdDataTableSortChangeEvent, TdDataTableSortingOrder } from '@covalent/core/data-table';
import { RetailEndpoint } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoints-grid',
  templateUrl: './endpoints-grid.component.html',
  styleUrls: ['./endpoints-grid.component.scss']
})
export class EndpointsGridComponent implements OnInit {


  public atomicData : RetailEndpoint[] = [];

  sortBy: string = 'retailEndpointName';
  sortOrder: TdDataTableSortingOrder = TdDataTableSortingOrder.Descending;

  constructor(
    private endpointsService : EndpointsService
  ) { }


  ngOnInit(): void {
    this.endpointsService.getEndpoints().subscribe(
      data => {
        //console.log(data);
        this.atomicData = data;
        this.filterData();
      }
    )
  }

  sort(sortEvent: ITdDataTableSortChangeEvent): void {
    this.sortOrder =
      this.sortOrder === TdDataTableSortingOrder.Ascending
        ? TdDataTableSortingOrder.Descending
        : TdDataTableSortingOrder.Ascending;
    this.sortBy = sortEvent.name;
    this.filterData();
  }

  private filterData(): void {
    this.atomicData = Array.from(this.atomicData); // Change the array reference to trigger OnPush
    this.atomicData.sort((a: any, b: any) => {
      let direction: number = 0;
      if (this.sortOrder === TdDataTableSortingOrder.Descending) {
        direction = 1;
      } else if (this.sortOrder === TdDataTableSortingOrder.Ascending) {
        direction = -1;
      }
      if (a[this.sortBy] < b[this.sortBy]) {
        return direction;
      } else if (a[this.sortBy] > b[this.sortBy]) {
        return -direction;
      } else {
        return direction;
      }
    });
  }
 

}
