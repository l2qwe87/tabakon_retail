import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EndpointsGridComponent } from './endpoints-grid.component';

describe('EndpointsGridComponent', () => {
  let component: EndpointsGridComponent;
  let fixture: ComponentFixture<EndpointsGridComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EndpointsGridComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EndpointsGridComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
