import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PaillierComponent } from './paillier.component';

describe('PaillierComponent', () => {
  let component: PaillierComponent;
  let fixture: ComponentFixture<PaillierComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PaillierComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PaillierComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
