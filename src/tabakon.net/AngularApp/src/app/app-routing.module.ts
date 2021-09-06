import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { CheckMarkComponent } from './mark/check-mark/check-mark.component';
import { EndpointDetailComponent } from './stats/endpoint-detail/endpoint-detail.component';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';

const routes: Routes = [
  //{ path : 'home', component : HomeComponent },
  {
    path : 'endpoints', children: [
      { path : 'grid', component : EndpointsGridComponent },
      { path : ':retailEndpointIdentity', component : EndpointDetailComponent },      
    ],
  },
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
