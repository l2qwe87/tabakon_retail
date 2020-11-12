import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EndpointExtConfigurationComponent } from './endpoint-ext-configuration.component';

describe('EndpointExtConfigurationComponent', () => {
  let component: EndpointExtConfigurationComponent;
  let fixture: ComponentFixture<EndpointExtConfigurationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EndpointExtConfigurationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EndpointExtConfigurationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
