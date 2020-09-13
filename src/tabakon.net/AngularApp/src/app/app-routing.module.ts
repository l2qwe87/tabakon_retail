import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { VersionsComponent } from './stats/versions/versions.component';

const routes: Routes = [
  { 
      path : 'stats', children: [
        {path : 'versions', component : VersionsComponent}
      ] 
}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
