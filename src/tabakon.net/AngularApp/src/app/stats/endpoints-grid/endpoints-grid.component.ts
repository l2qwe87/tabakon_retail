import { Component, OnInit, ViewChild } from '@angular/core';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { RetailEndpoint, RetailExtConfiguration } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoints-grid',
  templateUrl: './endpoints-grid.component.html',
  styleUrls: ['./endpoints-grid.component.scss']
})
export class EndpointsGridComponent implements OnInit {

  private _internalData : RetailEndpoint[] = [];
  public atomicData : RetailEndpoint[] = [];

  @ViewChild(MatSort) matSort: MatSort;
  sortBy: string = 'retailEndpointName';
  //sortOrder: TdDataTableSortingOrder = TdDataTableSortingOrder.Ascending;
  dataSource = new MatTableDataSource<RetailEndpoint>();

  displayedColumns: string[] = ['npp', 'retailEndpointName', 'retailEndpointUrl', 'retailExtConfiguration', 'retailEndpointVersion'];

  constructor(
    private endpointsService : EndpointsService
  ) { }

    ngOnInit(): void {
    this.endpointsService.getEndpoints()
      .subscribe(v =>{
        this.dataSource.data = v;
      });
  }

  // ngOnInit(): void {
  //   this.endpointsService.getEndpoints()
  //     .subscribe(v =>{
  //       this._internalData = v;

  //       this.filterData();
  //     });
  // }

  getColorForExtConfiguration(retailExtConfiguration : RetailExtConfiguration){
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'//'primary'
    if(retailExtConfiguration.jsonData == 'Beta')
      return 'accent'
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'

  }

  // sort(sortEvent: ITdDataTableSortChangeEvent): void {
  //   this.sortOrder =
  //     this.sortOrder === TdDataTableSortingOrder.Ascending
  //       ? TdDataTableSortingOrder.Descending
  //       : TdDataTableSortingOrder.Ascending;
  //   this.sortBy = sortEvent.name;
  //   this.filterData();
  // }

  // static FILTER_TERM : string = '';
  // private _filterTerm : string = '';
  // set filterTerm(value : string) { 
  //   //EndpointsGridComponent.FILTER_TERM = value; 
  //   this._filterTerm = value;
  // } 
  // get filterTerm() : string { 
  //   //return EndpointsGridComponent.FILTER_TERM
  //   return this._filterTerm;
  // } 


  // filter(filterTerm: string): void {
  //   this.filterTerm = filterTerm;
  //   this.filterData();
  // }


  // private filterData(): void {
  //   this.atomicData = Array.from(this._internalData); // Change the array reference to trigger OnPush

  //   if(this.filterTerm){

  //     let searchData = this.filterTerm.toLowerCase();

  //     this.atomicData = this.atomicData.filter(e => {
  //       let elJson = JSON.stringify(e).toLowerCase()
  //       let searchResult = elJson.search(searchData)
  //       return searchResult != -1;
  //     })
  //   }

  //   this.atomicData.sort((a: RetailEndpoint, b: RetailEndpoint) => {
  //     let direction: number = 0;
  //     if (this.sortOrder === TdDataTableSortingOrder.Descending) {
  //       direction = 1;
  //     } else if (this.sortOrder === TdDataTableSortingOrder.Ascending) {
  //       direction = -1;
  //     }

  //     let leftValue = a[this.sortBy];
  //     let rightValue = b[this.sortBy];

  //     if(this.sortBy == "retailEndpointVersion"){
        
  //       if(a.extData.retailVersion)
  //         leftValue = a.extData.retailVersion.jsonData;

  //       if(b.extData.retailVersion)
  //         rightValue = b.extData.retailVersion.jsonData;

  //     }

  //     if (leftValue < rightValue) {
  //       return direction;
  //     } else if (leftValue > rightValue) {
  //       return -direction;
  //     } else {
  //       return direction;
  //     }
  //   });

  //   this.atomicData.forEach((e : any) => e.retailEndpointVersion )  
  // }
 

}
