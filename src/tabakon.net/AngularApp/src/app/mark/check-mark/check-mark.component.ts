import { Component, OnInit } from '@angular/core';
import { MarkService } from '../mark.service';

@Component({
  selector: 'app-check-mark',
  templateUrl: './check-mark.component.html',
  styleUrls: ['./check-mark.component.scss']
})
export class CheckMarkComponent implements OnInit {

  constructor(
    private markService :  MarkService
  ) 
  { 

  }


  public markInfo : any[] = [];


  public getMarkInfo(mark : string)
  {
    console.log("getMarkInfo "+mark);
    this.markService.getMarkInfo(mark).subscribe(markInfo => {
      if(typeof markInfo === 'string'){
        this.markInfo=JSON.parse(markInfo)
      }else{
        this.markInfo = markInfo;
      }
    });
  }



  public markChange(){
    console.log("markChange");
  }

  ngOnInit(): void {
  }

}
