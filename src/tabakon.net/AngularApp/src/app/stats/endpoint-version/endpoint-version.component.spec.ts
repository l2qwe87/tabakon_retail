import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EndpointVersionComponent } from './endpoint-version.component';

describe('EndpointVersionComponent', () => {
  let component: EndpointVersionComponent;
  let fixture: ComponentFixture<EndpointVersionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EndpointVersionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EndpointVersionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
