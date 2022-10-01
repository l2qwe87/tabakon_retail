import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CashierCheckInfoEndpointComponent } from './cashier-check-info-endpoint.component';

describe('CashierCheckInfoEndpointComponent', () => {
  let component: CashierCheckInfoEndpointComponent;
  let fixture: ComponentFixture<CashierCheckInfoEndpointComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CashierCheckInfoEndpointComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CashierCheckInfoEndpointComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
