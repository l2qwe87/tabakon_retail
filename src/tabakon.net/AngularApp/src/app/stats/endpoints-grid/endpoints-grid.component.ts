import { Component, OnInit, ViewChild } from '@angular/core';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { BehaviorSubject } from 'rxjs';
import { RetailEndpoint, RetailExtConfiguration } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoints-grid',
  templateUrl: './endpoints-grid.component.html',
  styleUrls: ['./endpoints-grid.component.scss']
})
export class EndpointsGridComponent implements OnInit {

  public atomicData : RetailEndpoint[] = [];
  public filterValue: string = "";

  @ViewChild(MatSort) matSort: MatSort;
  sortBy: string = 'retailEndpointName';
  //sortOrder: TdDataTableSortingOrder = TdDataTableSortingOrder.Ascending;
  dataSource = new MatTableDataSource<RetailEndpoint>();

  displayedColumns: string[] = ['npp', 'retailEndpointName', 'retailEndpointUrl', 'retailExtConfiguration', 'retailEndpointVersion'];

  constructor(
    private endpointsService : EndpointsService
  ) { }


  $isLoading = new BehaviorSubject(true);

  ngOnInit(): void {
    
  }

  ngAfterViewInit() {
    this.dataSource.sort = this.matSort;
    this.endpointsService.getEndpoints().subscribe(data => {
      this.dataSource.data = data;
      this.$isLoading.next(false);
    });
    
    const defaultPredict = this.dataSource.filterPredicate;
    this.dataSource.filterPredicate = (item, filter) => {
      return defaultPredict(item, filter) || item.extData.retailExtConfiguration.jsonData.toLowerCase().indexOf(filter) !== -1;
    }
  }

  getColorForExtConfiguration(retailExtConfiguration : RetailExtConfiguration){
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'//'primary'
    if(retailExtConfiguration.jsonData == 'Beta')
      return 'accent'
    if(retailExtConfiguration.jsonData == 'Release')
      return 'warn'

  }

  applyFilter() {
    this.$isLoading.next(true);
    const filterValue = this.filterValue;
    this.dataSource.filter = filterValue.trim().toLowerCase();
    setTimeout(()=>this.$isLoading.next(false), 200);
    
  }

  filterByExtType(retailExtConfiguration : RetailExtConfiguration){
    this.filterValue = retailExtConfiguration.jsonData;
    this.applyFilter();
  }
}

