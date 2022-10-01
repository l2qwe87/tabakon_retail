import { TestBed } from '@angular/core/testing';

import { CashierCheckService } from './cashier-check.service';

describe('CashierCheckService', () => {
  let service: CashierCheckService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CashierCheckService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
