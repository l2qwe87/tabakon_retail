import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-endpoint-detail',
  templateUrl: './endpoint-detail.component.html',
  styleUrls: ['./endpoint-detail.component.scss']
})
export class EndpointDetailComponent implements OnInit {

  
  constructor(
    private route: ActivatedRoute,
  ) { }

  retailEndpointIdentity : string = "";
  ngOnInit(): void {
    let params = this.route.snapshot.params;
    if (params.retailEndpointIdentity){
      this.retailEndpointIdentity = params.retailEndpointIdentity;
    }
  }

}
