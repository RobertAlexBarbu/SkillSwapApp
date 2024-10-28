import {
    ChangeDetectionStrategy,
    Component,
    DestroyRef,
    inject,
} from '@angular/core'
import { MatButton } from '@angular/material/button'
import { UserStore } from '../../../../core/stores/user.store'
import { UserService } from '../../../../core/http/services/user/user.service'
import { BehaviorSubject, switchMap, take } from 'rxjs'
import { takeUntilDestroyed } from '@angular/core/rxjs-interop'
import { Router } from '@angular/router'
import { AsyncPipe } from '@angular/common'
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms'
import { MatError, MatFormField, MatLabel } from '@angular/material/form-field'
import { MatInput } from '@angular/material/input'
import { SingleImageUpload } from '../../../../shared/components/single-image-upload/single-image-upload'
import { emailValidator } from '../../../../shared/validators/emailValidator'
import {
    StudentVerificationService
} from '../../../../core/http/services/student-verification/student-verification.service'
import { VerificationRequestDto } from '../../../../core/http/dto/verification-request/verification-request.dto'
import {
    CreateVerificationRequestDto
} from '../../../../core/http/dto/verification-request/create-verification-request.dto'

@Component({
    selector: 'app-configure-page',
    standalone: true,
    imports: [MatButton, AsyncPipe, FormsModule, MatError, MatFormField, MatInput, MatLabel, ReactiveFormsModule, SingleImageUpload],
    templateUrl: './configure-page.component.html',
    styleUrl: './configure-page.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ConfigurePageComponent {
    private readonly userService = inject(UserService)
    private readonly userStore = inject(UserStore)
    private readonly destroyRef = inject(DestroyRef)
    private readonly router = inject(Router)
    private readonly studentVerificationService = inject(StudentVerificationService);

    disabled$ = new BehaviorSubject<boolean>(false)
    form = new FormGroup({
        studentName: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required],
        }),
        studentId: new FormControl<string>('', {
            nonNullable: true,
            validators: [Validators.required],
        }),
    })
    file: File | null = null;
    
    submit() {
        if (this.form.valid) {
            const rawForm = this.form.getRawValue()

            this.disabled$.next(true)
            this.userStore.user$.pipe(
                take(1),
                switchMap(user => {
                    const userId = user.id;
                    const createVerificationRequestDto: CreateVerificationRequestDto = {
                        userId: userId,
                        studentId: rawForm.studentId,
                        studentName: rawForm.studentName
                    }
                    return this.studentVerificationService.createVerificationRequest(createVerificationRequestDto)
                }),
                switchMap(() => {
                    return this.userService.configureByToken();
                }),
                takeUntilDestroyed(this.destroyRef)
            ).subscribe({
                next: value => {
                    this.userStore.configure(value)
                    this.router.navigate(['/private/main'])
                    this.disabled$.next(false)
                },
                error: () => {
                    this.disabled$.next(false)
                },
            })
        }
    }
    
}
