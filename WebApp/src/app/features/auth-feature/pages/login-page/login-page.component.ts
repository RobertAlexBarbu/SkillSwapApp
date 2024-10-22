import {
    ChangeDetectionStrategy,
    Component,
    DestroyRef,
    inject,
} from '@angular/core'
import { AuthService } from '../../../../core/services/auth/auth.service'
import { ErrorService } from '../../../../core/services/error/error.service'
import { UserStore } from '../../../../core/stores/user.store'
import { Router, RouterLink } from '@angular/router'
import { BehaviorSubject } from 'rxjs'
import {
    FormControl,
    FormGroup,
    ReactiveFormsModule,
    Validators,
} from '@angular/forms'
import { takeUntilDestroyed } from '@angular/core/rxjs-interop'
import {
    MatError,
    MatFormField,
    MatLabel,
    MatSuffix,
} from '@angular/material/form-field'
import { AsyncPipe } from '@angular/common'
import { MatIcon } from '@angular/material/icon'
import { MatButton, MatIconButton } from '@angular/material/button'
import { OrDividerComponent } from '../../../../shared/components/or-divider/or-divider.component'
import { DividerComponent } from '../../../../shared/components/divider/divider.component'
import { MatInput } from '@angular/material/input'
import { emailValidator } from '../../../../shared/validators/emailValidator'
import { EnvironmentService } from '../../../../core/services/environment/environment.service'

@Component({
    selector: 'app-login-page',
    standalone: true,
    imports: [
        ReactiveFormsModule,
        MatFormField,
        MatError,
        MatLabel,
        AsyncPipe,
        MatIcon,
        MatButton,
        RouterLink,
        OrDividerComponent,
        DividerComponent,
        MatIconButton,
        MatInput,
        MatSuffix,
    ],
    templateUrl: './login-page.component.html',
    styleUrl: './login-page.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class LoginPageComponent {
    visiblePassword$: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(
        false
    )
    visiblePassword = false
    shake$: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false)
    disabled$: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false)
    googleDisabled$: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(
        false
    )
    form = new FormGroup({
        email: new FormControl<string>('', {
            validators: [Validators.required, emailValidator],
            nonNullable: true,
        }),
        password: new FormControl<string>('', {
            validators: [Validators.required],
            nonNullable: true,
        }),
    })
    private readonly auth = inject(AuthService)
    private readonly errorService = inject(ErrorService)
    private readonly userStore = inject(UserStore)
    private readonly router = inject(Router)
    private readonly destroyRef = inject(DestroyRef)
    private readonly environmentService = inject(EnvironmentService)

    togglePasswordVisibility() {
        this.visiblePassword = !this.visiblePassword
        this.visiblePassword$.next(this.visiblePassword)
    }

    submit() {
        if (this.form.valid) {
            const rawForm = this.form.getRawValue()
            this.disabled$.next(true)
            this.auth
                .loginWithEmail(rawForm.email, rawForm.password)
                .pipe(takeUntilDestroyed(this.destroyRef))
                .subscribe({
                    next: (userDto) => {
                        this.userStore.logIn(userDto)
                        this.router.navigateByUrl('/private/main')
                    },
                    error: (error) => {
                        this.shake$.next(true)
                        this.disabled$.next(false)
                        setTimeout(() => {
                            this.shake$.next(false)
                        }, 500)
                        this.errorService.handleError(error)
                    },
                })
        }
    }

    loginWithGoogle() {
        if (this.environmentService.getRedirectAuth()) {
            this.auth.loginWithGoogleRedirect()
        } else {
            this.auth
                .loginWithGoogle()
                .pipe(takeUntilDestroyed(this.destroyRef))
                .subscribe({
                    next: (userDto) => {
                        this.userStore.logIn(userDto)
                        this.router.navigateByUrl('/private/main')
                    },
                    error: (error) => {
                        this.errorService.handleError(error)
                    },
                })
        }
    }
}
