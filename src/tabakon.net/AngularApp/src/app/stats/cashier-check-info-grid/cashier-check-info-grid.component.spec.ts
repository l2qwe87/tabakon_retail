import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CashierCheckInfoGridComponent } from './cashier-check-info-grid.component';

describe('CashierCheckInfoGridComponent', () => {
  let component: CashierCheckInfoGridComponent;
  let fixture: ComponentFixture<CashierCheckInfoGridComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CashierCheckInfoGridComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CashierCheckInfoGridComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
