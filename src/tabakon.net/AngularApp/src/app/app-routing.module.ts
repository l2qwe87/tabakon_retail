import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';
import { VersionsComponent } from './stats/versions/versions.component';

const routes: Routes = [
  { path : 'home', component : HomeComponent },
  {
    path : 'stats', children: [
      { path : 'versions', component : VersionsComponent },
      { path : 'endpoints-grid', component : EndpointsGridComponent },
    ] 
}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
