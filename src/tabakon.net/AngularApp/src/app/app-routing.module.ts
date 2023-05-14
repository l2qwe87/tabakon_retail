import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CheckMarkComponent } from './mark/check-mark/check-mark.component';
import { EndpointDetailComponent } from './stats/endpoint-detail/endpoint-detail.component';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';
import { CashierCheckInfoPageComponent } from './stats/cashier-check-info-page/cashier-check-info-page.component';

const routes: Routes = [
  //{ path : 'home', component : HomeComponent },
  {
    path : 'endpoints', children: [
      { path : 'grid', component : EndpointsGridComponent },
      { path : ':retailEndpointIdentity', component : EndpointDetailComponent },      
    ],
  },
  { path : 'cash', component : CashierCheckInfoPageComponent },
  {
    path : 'mark', children: [
      { path : 'check', component : CheckMarkComponent },
    ],
  },

  
  { path : '**', component : EndpointsGridComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
