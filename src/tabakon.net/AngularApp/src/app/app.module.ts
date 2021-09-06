import { CovalentLayoutModule } from '@covalent/core/layout';
import { CovalentStepsModule  } from '@covalent/core/steps';
/* any other core modules */
// (optional) Additional Covalent Modules imports
import { CovalentHttpModule } from '@covalent/http';
import { CovalentHighlightModule } from '@covalent/highlight';
import { CovalentMarkdownModule } from '@covalent/markdown';
import { CovalentDynamicFormsModule } from '@covalent/dynamic-forms';
import { CovalentBaseEchartsModule } from '@covalent/echarts/base';
import { CovalentDataTableModule } from '@covalent/core/data-table';
import { CovalentSearchModule } from '@covalent/core/search';

import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HomeComponent } from './home/home.component';
import { CommonComponentsModule } from './common-components-module/common-components-module.module';
import { HttpClientModule } from '@angular/common/http';
import { EndpointsGridComponent } from './stats/endpoints-grid/endpoints-grid.component';
import { EndpointsService } from './services/endpoints.service';
import { EndpointVersionComponent } from './stats/endpoint-version/endpoint-version.component';
import { EndpointDetailComponent } from './stats/endpoint-detail/endpoint-detail.component';
import { EndpointExtConfigurationComponent } from './stats/endpoint-ext-configuration/endpoint-ext-configuration.component';
import { CovalentLoadingModule } from '@covalent/core/loading';
import { CovalentDialogsModule } from '@covalent/core/dialogs';
import { CheckMarkComponent } from './mark/check-mark/check-mark.component';
import { MarkInfoComponent } from './mark/mark-info/mark-info.component';



@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    EndpointsGridComponent,
    EndpointVersionComponent,
    EndpointDetailComponent,
    EndpointExtConfigurationComponent,
    CheckMarkComponent,
    MarkInfoComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,

    CovalentLayoutModule,
    CovalentStepsModule,
    // (optional) Additional Covalent Modules imports
    CovalentHttpModule.forRoot(),
    CovalentHighlightModule,
    CovalentMarkdownModule,
    CovalentDynamicFormsModule,
    CovalentBaseEchartsModule,
    CovalentDataTableModule,
    CovalentSearchModule,
    CovalentLoadingModule,
    CovalentDialogsModule,

    BrowserAnimationsModule,
    CommonComponentsModule,

    HttpClientModule,
    
  ],
  providers: [
    { provide : EndpointsService }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
