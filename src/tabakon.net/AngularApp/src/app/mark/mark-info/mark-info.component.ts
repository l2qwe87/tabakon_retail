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
      {label: "Статус", value: this.GetStatus(v.cisInfo.status)},
      {label: "Товар", value: v.cisInfo.productName},
    ]

    console.log(this.props);

  };


  public getCisClassByStatuse():string {
    let _class = null;
    let requestedCis: string | null = this.info?.cisInfo?.requestedCis;
    if(requestedCis != null){
      let hasDoubleChars = requestedCis.length == 30 && requestedCis.indexOf("AAAA") && requestedCis[27] == requestedCis[28];

      if(hasDoubleChars){
        _class = "RED_COLOR";
      }
    }else{
      _class = "RED_COLOR";
    }
    return _class ?? this.info?.cisInfo?.status ?? "NOT_FOUND";
  }

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

  public GetStatus(v : string):string
  {
    return this._statusEnum[v] ?? v;
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
