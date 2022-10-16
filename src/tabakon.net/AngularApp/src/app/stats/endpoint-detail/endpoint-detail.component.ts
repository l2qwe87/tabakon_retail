import { Component, OnDestroy, OnInit, ViewContainerRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { first, switchMap, tap } from 'rxjs/operators';
import { RetailEndpoint } from 'src/app/models/RetailEndpoint';
import { EndpointsService } from 'src/app/services/endpoints.service';
import { TdLoadingService } from '@covalent/core/loading';
import { TdDialogService } from '@covalent/core/dialogs';

@Component({
  selector: 'app-endpoint-detail',
  templateUrl: './endpoint-detail.component.html',
  styleUrls: ['./endpoint-detail.component.scss']
})
export class EndpointDetailComponent implements OnInit, OnDestroy {

  
  constructor(
    private route: ActivatedRoute,
    private endpointsService : EndpointsService,
    private _loadingService: TdLoadingService,
    private _dialogService: TdDialogService,
    private _viewContainerRef: ViewContainerRef
  ) { }

  retailEndpointIdentity : string = "";
  retailEndpoint : RetailEndpoint;

  ngOnInit(): void {
    let params = this.route.snapshot.params;
    if (params.retailEndpointIdentity){
      this.retailEndpointIdentity = params.retailEndpointIdentity;
    }

    this._loadingService.register("endpointDetail");

    this._subs.push(
      this.endpointsService.getEndpoints().subscribe( endpoints =>{
        let endpoint = endpoints.filter( e=> e.retailEndpointIdentity == this.retailEndpointIdentity)
        if(endpoint.length > 0)
          this.retailEndpoint = endpoint[0];

        this._loadingService.resolve("endpointDetail");
      })
    )
  }


  changeExtConfiguration():void{
    let msg = 
    this._dialogService.openPrompt({
      message: 'Введите название конфигурации (`Release`, `Beta`, `Alpha`), текущая конфигурация '+this.retailEndpoint.extData.retailExtConfiguration.jsonData+'',
      disableClose: false, // defaults to false
      viewContainerRef: this._viewContainerRef, //OPTIONAL
      title: 'Изменить конфигурацию расширения', //OPTIONAL, hides if not provided
      value: '', //OPTIONAL
      cancelButton: 'Cancel', //OPTIONAL, defaults to 'CANCEL'
      acceptButton: 'Ok', //OPTIONAL, defaults to 'ACCEPT'
      width: '400px', //OPTIONAL, defaults to 400px
    }).afterClosed().subscribe((newValue: string) => {
      if (newValue) {
        this.changeExtConfigurationInternal(newValue);
      } else {
      }
    });
  }

  private changeExtConfigurationInternal(newValue : string){

    let allowable = ['Release','Beta','Alpha']

    if(allowable.filter(e => e == newValue).length == 0 ){
      this._dialogService.openAlert({
        title: 'Ошибка',
        disableClose: true,
        message: 'Вы ввыели, `'+newValue+'`, допустимы только (`Release`, `Beta`, `Alpha`) ',
      });
    } else {
      this._loadingService.register("endpointDetail");
      this._subs.push(
        this.endpointsService.setRetailExtConfiguration(this.retailEndpointIdentity, newValue).pipe(
          first(),
          tap(v => this.retailEndpoint.extData.retailExtConfiguration = v),
        ).subscribe(v => {
          this._loadingService.resolve("endpointDetail");
        })
      );
    }

  }

  run_apply_cfe():void{
    this._loadingService.register("endpointDetail");
    this._subs.push(
      this.endpointsService.run_apply_cfe(this.retailEndpointIdentity).pipe(
        first(),
      ).subscribe(v => {
        this._loadingService.resolve("endpointDetail");
      }),
    )
  }

  run_exRetailOle():void{
    this._loadingService.register("endpointDetail");
    this._subs.push(
      this.endpointsService.run_apply_cfe(this.retailEndpointIdentity).pipe(
        first(),
      ).subscribe(v => {
        this._loadingService.resolve("endpointDetail");
      }),
    )
  }

  updateData():void{

    this._loadingService.register("endpointDetail");
    this._loadingService.register("endpointCash");
    
    this._subs.push(
      this.endpointsService.getRetailVersion(this.retailEndpointIdentity).pipe(
        first(),
        tap(v => this.retailEndpoint.extData.retailVersion = v),
        switchMap(v => this.endpointsService.getRetailExtConfiguration(this.retailEndpointIdentity)),
        first(),
        tap(v => this.retailEndpoint.extData.retailExtConfiguration = v)
      ).subscribe(v => {
        this._loadingService.resolve("endpointDetail");
      }),

      this.endpointsService.updateData(this.retailEndpointIdentity).pipe(
        first(),
      ).subscribe( _ => this._loadingService.resolve("endpointCash")),
      
    )
  }

  private _subs : Subscription[] = [];
  ngOnDestroy():void{ 
      this._subs.forEach( e => e.unsubscribe());
  }

}
