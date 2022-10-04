import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CashierCheckInfoPageComponent } from './cashier-check-info-page.component';

describe('CashierCheckInfoPageComponent', () => {
  let component: CashierCheckInfoPageComponent;
  let fixture: ComponentFixture<CashierCheckInfoPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CashierCheckInfoPageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CashierCheckInfoPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
