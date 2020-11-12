import { Component, Input, OnInit } from '@angular/core';
import { RetailExtConfiguration } from 'src/app/models/RetailEndpoint';

@Component({
  selector: 'app-endpoint-ext-configuration',
  templateUrl: './endpoint-ext-configuration.component.html',
  styleUrls: ['./endpoint-ext-configuration.component.scss']
})
export class EndpointExtConfigurationComponent implements OnInit {

  constructor() { }

  @Input()
  public retailExtConfiguration : RetailExtConfiguration;
  ngOnInit(): void {
  }

  get isRelease() : boolean {
    return this.retailExtConfiguration.jsonData == "Release"
  }
  get isBeta() : boolean {
    return this.retailExtConfiguration.jsonData == "Beta"
  }
  get isAlpha() : boolean {
    return this.retailExtConfiguration.jsonData == "Alpha"
  }
}
