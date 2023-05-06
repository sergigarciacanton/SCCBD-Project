import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BlindSignatureComponent } from './blind-signature.component';

describe('BlindSignatureComponent', () => {
  let component: BlindSignatureComponent;
  let fixture: ComponentFixture<BlindSignatureComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BlindSignatureComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BlindSignatureComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
