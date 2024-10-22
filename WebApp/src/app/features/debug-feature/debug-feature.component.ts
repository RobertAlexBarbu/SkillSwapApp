import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { AsyncPipe, NgIf } from '@angular/common'
import { MatButton } from '@angular/material/button'
import { UserStore } from '../../core/stores/user.store'
import { TestService } from '../../core/http/services/test/test.service'
import { BehaviorSubject } from 'rxjs'

@Component({
    selector: 'app-debug-feature',
    standalone: true,
    imports: [AsyncPipe, MatButton, NgIf],
    templateUrl: './debug-feature.component.html',
    styleUrl: './debug-feature.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DebugFeatureComponent {
    unprotectedResult$ = new BehaviorSubject<string>('')
    protectedResult$ = new BehaviorSubject<string>('')
    adminProtectedResult$ = new BehaviorSubject<string>('')
    protected readonly localStorage = localStorage
    private readonly userStore = inject(UserStore)
    user$ = this.userStore.user$
    private readonly testService = inject(TestService)

    removeAccessToken() {
        localStorage.removeItem('access')
    }

    removeRefreshToken() {
        localStorage.removeItem('refresh')
    }

    makeProtectedRequest() {
        this.protectedResult$.next('Pending...')
        this.testService.getProtected().subscribe({
            next: () => {
                this.protectedResult$.next('Success')
            },
            error: (err) => {
                this.protectedResult$.next('Error')
                console.log(err)
            },
        })
    }

    makeAdminProtectedRequest() {
        this.adminProtectedResult$.next('Pending...')
        this.testService.getAdminProtected().subscribe({
            next: () => {
                this.adminProtectedResult$.next('Success')
            },
            error: (err) => {
                this.adminProtectedResult$.next('Error')
                console.log(err)
            },
        })
    }

    makeUnprotectedRequest() {
        this.unprotectedResult$.next('Pending...')
        this.testService.getUnprotected().subscribe({
            next: () => {
                this.unprotectedResult$.next('Success')
            },
            error: () => {
                this.unprotectedResult$.next('Error')
            },
        })
    }
}
