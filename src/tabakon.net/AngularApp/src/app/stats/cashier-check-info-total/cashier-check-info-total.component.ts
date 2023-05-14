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

  data: ICashierCheckInfoTotal;

  constructor(
    private cashierCheckService: CashierCheckService
  ) { }

  ngOnInit(): void {
    this.cashierCheckService.getInfoTotal((this.date instanceof Date ? this.date.toJSON() : this.date)).pipe(

    ).subscribe( data => this.data = data);
  }

}
