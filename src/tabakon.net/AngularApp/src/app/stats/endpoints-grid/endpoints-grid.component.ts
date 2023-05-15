import { Component, OnInit, ViewChild } from '@angular/core';
import { FormControl } from '@angular/forms';
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

  $isLoading = new BehaviorSubject(true);
  filterControl = new FormControl('');
  dataSource = new MatTableDataSource<RetailEndpoint>();
  displayedColumns: string[] = ['npp', 'retailEndpointName', 'retailEndpointUrl', 'retailExtConfiguration', 'retailEndpointVersion'];

  @ViewChild(MatSort) matSort: MatSort;

  constructor(
    private endpointsService : EndpointsService
  ) { }
  
  ngOnInit(): void { }

  ngAfterViewInit() {
    
    this.endpointsService.getEndpoints().subscribe(data => {
      this.dataSource.data = data;
      this.$isLoading.next(false);
    });
    
    this.dataSource.sort = this.matSort;

    const defaultPredict = this.dataSource.filterPredicate;
    this.dataSource.filterPredicate = (item, filter) => {
      
      if(item?.extData?.retailExtConfiguration?.jsonData?.toLowerCase()?.indexOf(filter) !== -1){
        return true
      }

      if(Object.keys(item).filter(key => item[key]?.toString()?.toLowerCase()?.indexOf(filter) !== -1).length){
        return true;
      }

      return false;

    }

    this.filterControl.valueChanges.subscribe(value => this.applyFilter());
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
    const filterValue = this.filterControl.value;
    this.dataSource.filter = filterValue.trim().toLowerCase();
    setTimeout(()=>this.$isLoading.next(false), 200);
    
  }

  filterByExtType(retailExtConfiguration : RetailExtConfiguration){
    this.filterControl.setValue(retailExtConfiguration.jsonData);
    //this.applyFilter();
  }
}

