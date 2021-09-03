import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MarkInfoComponent } from './mark-info.component';

describe('MarkInfoComponent', () => {
  let component: MarkInfoComponent;
  let fixture: ComponentFixture<MarkInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MarkInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MarkInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
