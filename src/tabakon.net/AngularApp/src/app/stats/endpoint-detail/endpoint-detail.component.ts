import { Component, OnDestroy, OnInit, ViewContainerRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription, BehaviorSubject } from 'rxjs';
import { first, switchMap, tap } from 'rxjs/operators';
import { RetailEndpoint } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';

@Component({
  selector: 'app-endpoint-detail',
  templateUrl: './endpoint-detail.component.html',
  styleUrls: ['./endpoint-detail.component.scss']
})
export class EndpointDetailComponent implements OnInit, OnDestroy {

  
  $isLoadingEndpointDetail = new BehaviorSubject(true);
  $isLoadingEndpointCash = new BehaviorSubject(false);

  constructor(
    private route: ActivatedRoute,
    private endpointsService : EndpointsService,
    private _viewContainerRef: ViewContainerRef
  ) { }

  retailEndpointIdentity : string = "";
  retailEndpoint : RetailEndpoint;

  ngOnInit(): void {
    let params = this.route.snapshot.params;
    if (params.retailEndpointIdentity){
      this.retailEndpointIdentity = params.retailEndpointIdentity;
    }

    this.$isLoadingEndpointDetail.next(true);

    this._subs.push(
      this.endpointsService.getEndpoints().subscribe( endpoints =>{
        let endpoint = endpoints.filter( e=> e.retailEndpointIdentity == this.retailEndpointIdentity)
        if(endpoint.length > 0)
          this.retailEndpoint = endpoint[0];

          this.$isLoadingEndpointDetail.next(false);
      })
    )
  }


  changeExtConfiguration():void{
    // let msg = 
    // this._dialogService.openPrompt({
    //   message: 'Введите название конфигурации (`Release`, `Beta`, `Alpha`), текущая конфигурация '+this.retailEndpoint.extData.retailExtConfiguration.jsonData+'',
    //   disableClose: false, // defaults to false
    //   viewContainerRef: this._viewContainerRef, //OPTIONAL
    //   title: 'Изменить конфигурацию расширения', //OPTIONAL, hides if not provided
    //   value: '', //OPTIONAL
    //   cancelButton: 'Cancel', //OPTIONAL, defaults to 'CANCEL'
    //   acceptButton: 'Ok', //OPTIONAL, defaults to 'ACCEPT'
    //   width: '400px', //OPTIONAL, defaults to 400px
    // }).afterClosed().subscribe((newValue: string) => {
    //   if (newValue) {
    //     this.changeExtConfigurationInternal(newValue);
    //   } else {
    //   }
    // });
  }

  private changeExtConfigurationInternal(newValue : string){

    let allowable = ['Release','Beta','Alpha']

    if(allowable.filter(e => e == newValue).length == 0 ){
      // this._dialogService.openAlert({
      //   title: 'Ошибка',
      //   disableClose: true,
      //   message: 'Вы ввыели, `'+newValue+'`, допустимы только (`Release`, `Beta`, `Alpha`) ',
      // });
    } else {
      this.$isLoadingEndpointDetail.next(true);
      this._subs.push(
        this.endpointsService.setRetailExtConfiguration(this.retailEndpointIdentity, newValue).pipe(
          first(),
          tap(v => this.retailEndpoint.extData.retailExtConfiguration = v),
        ).subscribe(v => {
          this.$isLoadingEndpointDetail.next(false);
        })
      );
    }

  }

  run_apply_cfe():void{
    this.$isLoadingEndpointDetail.next(true);
    this._subs.push(
      this.endpointsService.run_apply_cfe(this.retailEndpointIdentity).pipe(
        first(),
      ).subscribe(v => {
        this.$isLoadingEndpointDetail.next(false);  
      }),
    )
  }

  run_exRetailOle():void{
    this.$isLoadingEndpointDetail.next(true);
    this._subs.push(
      this.endpointsService.run_apply_cfe(this.retailEndpointIdentity).pipe(
        first(),
      ).subscribe(v => {
        this.$isLoadingEndpointDetail.next(false);
      }),
    )
  }

  updateData():void{

    this.$isLoadingEndpointDetail.next(true);
    this.$isLoadingEndpointCash.next(true);
    
    this._subs.push(
      this.endpointsService.getRetailVersion(this.retailEndpointIdentity).pipe(
        first(),
        tap(v => this.retailEndpoint.extData.retailVersion = v),
        switchMap(v => this.endpointsService.getRetailExtConfiguration(this.retailEndpointIdentity)),
        first(),
        tap(v => this.retailEndpoint.extData.retailExtConfiguration = v)
      ).subscribe(v => {
        this.$isLoadingEndpointDetail.next(false);
      }),

      this.endpointsService.updateData(this.retailEndpointIdentity).pipe(
        first(),
        ).subscribe( _ => this.$isLoadingEndpointCash.next(false)),
      
    )
  }

  private _subs : Subscription[] = [];
  
  ngOnDestroy():void{ 
      this._subs.forEach( e => e.unsubscribe());
  }

}
