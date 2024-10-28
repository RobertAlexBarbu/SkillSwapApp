import { TestBed } from '@angular/core/testing';

import { StudentVerificationService } from './student-verification.service';

describe('StudentVerificationService', () => {
  let service: StudentVerificationService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(StudentVerificationService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
