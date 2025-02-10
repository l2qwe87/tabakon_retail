import { Component, Input, OnInit } from '@angular/core';


interface IProp{
  label : string;
  value : string;
  class : string;
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
      {label: "Владелец", value: v.cisInfo.ownerName, class: ""},
      {label: "ИНН", value: v.cisInfo.ownerInn, class: ""},
      {label: "Статус", value: this.GetStatus(v.cisInfo.status), class: ""},
      {label: "Тип эмиссии", value: this.GetEmissionType(v.cisInfo.emissionType), class: this.GetEmissionTypeClass(v.cisInfo.emissionType)},
      {label: "Товар", value: v.cisInfo.productName, class: ""},
    ]

    console.log(this.props);

  };


  private _statusEnum = {
    "EMITTED" : "Эмитирован. Выпущен",
    "APPLIED" : "Эмитирован. Получен",
    "INTRODUCED" : "В обороте",
    "WRITTEN_OFF" : "Списан",
    "RETIRED" : "Выбыл",
    "WITHDRAWN" : "Выбыл",
    "INTRODUCED_RETURNED" : "Возвращён в оборот",
    "DISAGGREGATION" : "Расформирован",
    "DISAGGREGATED" : "Расформирован",
  };

  private _emissionType = {
    "LOCAL" : "LOCAL",
    "FOREIGN" : "FOREIGN",
    "REMAINS" : "REMAINS",
    "CROSSBORDER" : "CROSSBORDER",
    "REMARK" : "REMARK",
    "COMMISSION" : "COMMISSION",
    "AGGREGATION": "AGGREGATION",
  }

  public GetStatus(v : string):string
  {
    return this._statusEnum[v] ?? v;
  }

  public GetEmissionType(v : string):string
  {
    return this._emissionType[v] ?? v;
  }

  public GetEmissionTypeClass(v : string):string
  {
    if(v == "FOREIGN") { return "EM-FOREIGN" }
    if(v == "LOCAL") { return "EM-LOCAL" }
    return "";
  }

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
