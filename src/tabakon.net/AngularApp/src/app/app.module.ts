import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CommonComponentsModule } from './common-components-module/common-components-module.module';
import { HttpClientModule } from '@angular/common/http';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';
import { EndpointsService } from './services/endpoints.service';
import { CashierCheckService } from './services/cashier-check.service';
import { EndpointVersionComponent } from './stats/endpoint-version/endpoint-version.component';
import { EndpointDetailComponent } from './stats/endpoint-detail/endpoint-detail.component';
import { EndpointExtConfigurationComponent } from './stats/endpoint-ext-configuration/endpoint-ext-configuration.component';

import { CheckMarkComponent } from './mark/check-mark/check-mark.component';
import { MarkInfoComponent } from './mark/mark-info/mark-info.component';
import { CashierCheckInfoEndpointComponent } from './stats/cashier-check-info-endpoint/cashier-check-info-endpoint.component';
import { CashierCheckInfoGridComponent } from './stats/cashier-check-info-grid/cashier-check-info-grid.component';
import { CashierCheckInfoTotalComponent } from './stats/cashier-check-info-total/cashier-check-info-total.component';
import { CashierCheckInfoPageComponent } from './stats/cashier-check-info-page/cashier-check-info-page.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialogModule } from '@angular/material/dialog';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatMenuModule } from '@angular/material/menu';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTreeModule } from '@angular/material/tree';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';



@NgModule({
  declarations: [
    AppComponent,
    EndpointsGridComponent,
    EndpointVersionComponent,
    EndpointDetailComponent,
    EndpointExtConfigurationComponent,
    CheckMarkComponent,
    MarkInfoComponent,
    CashierCheckInfoEndpointComponent,
    CashierCheckInfoGridComponent,
    CashierCheckInfoTotalComponent,
    CashierCheckInfoPageComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,

    FormsModule,
    BrowserAnimationsModule,
    CommonComponentsModule,

    HttpClientModule,
    ReactiveFormsModule,
  ],
  providers: [
    { provide : EndpointsService },
    { provide : CashierCheckService }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
