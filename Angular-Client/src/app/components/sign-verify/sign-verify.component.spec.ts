import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SignVerifyComponent } from './sign-verify.component';

describe('SignVerifyComponent', () => {
  let component: SignVerifyComponent;
  let fixture: ComponentFixture<SignVerifyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [SignVerifyComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SignVerifyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
