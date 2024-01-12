import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MarkService } from '../mark.service';
import { FormControl } from '@angular/forms';
import { debounceTime, filter } from 'rxjs/operators';

@Component({
  selector: 'app-check-mark',
  templateUrl: './check-mark.component.html',
  styleUrls: ['./check-mark.component.scss']
})
export class CheckMarkComponent implements OnInit, AfterViewInit {

  mark = new FormControl('');

  constructor(
    private markService :  MarkService
  ) 
  {}

  
  ngOnInit(): void {}

  ngAfterViewInit(): void {
    this.mark.valueChanges.pipe(
      filter(mark => !!mark),
      debounceTime(200),
    ).subscribe( mark => this.getMarkInfo(mark)) 
  }
  

  public markInfo : any[] = [];
  public searchInput : string = "";


  public getMarkInfo(mark : string)
  {
    console.log("getMarkInfo "+mark);
    this.markInfo = [];
    this.markService.getMarkInfo(mark).subscribe(markInfo => {
      if(typeof markInfo === 'string'){
        this.markInfo=JSON.parse(markInfo)
      }else{
        this.markInfo = markInfo;
      }

      this.mark.patchValue("",{emitViewToModelChange: false});

    });
  }


}
