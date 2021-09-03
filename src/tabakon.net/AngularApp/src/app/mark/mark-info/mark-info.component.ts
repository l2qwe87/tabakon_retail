import { Component, Input, OnInit } from '@angular/core';


interface IProp{
  label : string;
  value : string;
}

@Component({
  selector: 'app-mark-info',
  templateUrl: './mark-info.component.html',
  styleUrls: ['./mark-info.component.scss']
})
export class MarkInfoComponent implements OnInit {


  private _info: any;
  @Input()
  public set  info(v: any){
    this._info = v;

    this.props = [
      {label: "Владелец", value: v.cisInfo.ownerName},
      {label: "ИНН", value: v.cisInfo.ownerInn},
      {label: "Статус", value: v.cisInfo.status},
      {label: "Товар", value: v.cisInfo.productName},
    ]

    console.log(this.props);

  };
  public get  info(): any{
    return this._info
  };
  
  public props : IProp[]

  constructor(

  ) 
  {

  }

  ngOnInit(): void {
  }

}
