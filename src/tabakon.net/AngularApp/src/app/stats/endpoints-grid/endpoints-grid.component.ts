import { Component, OnInit } from '@angular/core';
import { ITdDataTableSortChangeEvent, TdDataTableSortingOrder } from '@covalent/core/data-table';
import { combineLatest } from 'rxjs';

import { combineAll, switchMap } from 'rxjs/operators';
import { RetailEndpoint, RetailEndpointExtData, RetailExtConfiguration } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoints-grid',
  templateUrl: './endpoints-grid.component.html',
  styleUrls: ['./endpoints-grid.component.scss']
})
export class EndpointsGridComponent implements OnInit {

  private _internalData : RetailEndpoint[] = [];
  public atomicData : RetailEndpoint[] = [];

  sortBy: string = 'retailEndpointName';
  sortOrder: TdDataTableSortingOrder = TdDataTableSortingOrder.Ascending;

  constructor(
    private endpointsService : EndpointsService
  ) { }


  ngOnInit(): void {
    //combineLatest(this.endpointsService.getEndpoints(), this.endpointsService.getEndpointsVersion())
    this.endpointsService.getEndpoints()
      .subscribe(v =>{
        this._internalData = v;
        //this._internalData = v[0];
        // let endpointsVersions = v[1];
        // this._internalData.forEach(e =>{
        //   e.extData = {};

        //   let filterResult = endpointsVersions.filter(endpointsVersion => endpointsVersion.retailEndpointIdentity == e.retailEndpointIdentity)
        //   if(filterResult.length > 0){
        //     e.extData.retailVersion = filterResult[0];
        //   }else{
        //     e.extData.retailVersion = null;
        //   }
        // })

        this.filterData();
      });
  }

  getColorForExtConfiguration(retailExtConfiguration : RetailExtConfiguration){
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'//'primary'
    if(retailExtConfiguration.jsonData == 'Beta')
      return 'accent'
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'

  }

  sort(sortEvent: ITdDataTableSortChangeEvent): void {
    this.sortOrder =
      this.sortOrder === TdDataTableSortingOrder.Ascending
        ? TdDataTableSortingOrder.Descending
        : TdDataTableSortingOrder.Ascending;
    this.sortBy = sortEvent.name;
    this.filterData();
  }

  static FILTER_TERM : string = '';
  private _filterTerm : string = '';
  set filterTerm(value : string) { 
    EndpointsGridComponent.FILTER_TERM = value; 
    //this._filterTerm = value;
  } 
  get filterTerm() : string { 
    return EndpointsGridComponent.FILTER_TERM
    //return this._filterTerm;
  } 


  filter(filterTerm: string): void {
    this.filterTerm = filterTerm;
    this.filterData();
  }


  private filterData(): void {
    this.atomicData = Array.from(this._internalData); // Change the array reference to trigger OnPush

    if(this.filterTerm){

      let searchData = this.filterTerm.toLowerCase();

      this.atomicData = this.atomicData.filter(e => {
        let elJson = JSON.stringify(e).toLowerCase()
        let searchResult = elJson.search(searchData)
        return searchResult != -1;
      })
    }

    this.atomicData.sort((a: RetailEndpoint, b: RetailEndpoint) => {
      let direction: number = 0;
      if (this.sortOrder === TdDataTableSortingOrder.Descending) {
        direction = 1;
      } else if (this.sortOrder === TdDataTableSortingOrder.Ascending) {
        direction = -1;
      }

      let leftValue = a[this.sortBy];
      let rightValue = b[this.sortBy];

      if(this.sortBy == "retailEndpointVersion"){
        
        if(a.extData.retailVersion)
          leftValue = a.extData.retailVersion.jsonData;

        if(b.extData.retailVersion)
          rightValue = b.extData.retailVersion.jsonData;

      }

      if (leftValue < rightValue) {
        return direction;
      } else if (leftValue > rightValue) {
        return -direction;
      } else {
        return direction;
      }
    });

    this.atomicData.forEach((e : any) => e.retailEndpointVersion )  
  }
 

}
