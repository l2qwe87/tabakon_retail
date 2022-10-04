import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CashierCheckInfoTotalComponent } from './cashier-check-info-total.component';

describe('CashierCheckInfoTotalComponent', () => {
  let component: CashierCheckInfoTotalComponent;
  let fixture: ComponentFixture<CashierCheckInfoTotalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CashierCheckInfoTotalComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CashierCheckInfoTotalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
