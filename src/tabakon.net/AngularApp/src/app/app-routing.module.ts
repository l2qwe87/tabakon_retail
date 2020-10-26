import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';

const routes: Routes = [
  //{ path : 'home', component : HomeComponent },
  {
    path : 'stats', children: [
      { path : 'endpoints-grid', component : EndpointsGridComponent },
    ]
  },

  
  { path : '**', component : EndpointsGridComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
