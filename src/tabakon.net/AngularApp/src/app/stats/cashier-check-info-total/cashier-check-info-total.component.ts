import { Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { CashierCheckService } from 'src/app/services/cashier-check.service';

interface ICashierCheckInfoTotal{
  sumCash: number;
  sumTerminal: number;
}

@Component({
  selector: 'app-cashier-check-info-total',
  templateUrl: './cashier-check-info-total.component.html',
  styleUrls: ['./cashier-check-info-total.component.scss']
})
export class CashierCheckInfoTotalComponent implements OnInit {

  @Input()
  public date: Date;

  data$: Observable<ICashierCheckInfoTotal>;

  constructor(
    private cashierCheckService: CashierCheckService
  ) { }

  ngOnInit(): void {
    this.data$ = this.cashierCheckService.getInfoTotal(this.date);
  }

}
