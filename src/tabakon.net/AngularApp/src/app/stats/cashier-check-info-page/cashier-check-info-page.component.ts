import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-cashier-check-info-page',
  templateUrl: './cashier-check-info-page.component.html',
  styleUrls: ['./cashier-check-info-page.component.scss']
})
export class CashierCheckInfoPageComponent implements OnInit {


  today: string;
  yesterday: string;
  dayBeforeYesterday: string;

  constructor() { }

  ngOnInit(): void {
    let today = new Date();
    this.today = today.toISOString();
    
    let yesterday = new Date();
    yesterday.setDate(today.getDate() - 1 );
    this.yesterday = yesterday.toISOString();

    let dayBeforeYesterday = new Date();
    dayBeforeYesterday.setDate(today.getDate() - 2 );
    this.dayBeforeYesterday = dayBeforeYesterday.toISOString();
  }

}
