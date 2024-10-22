import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { RouterOutlet } from '@angular/router'
import { MatSlideToggle } from '@angular/material/slide-toggle'
import { MatProgressBar } from '@angular/material/progress-bar'
import { ProgressBarStore } from './core/stores/progress-bar.store'
import { AsyncPipe, NgIf } from '@angular/common'
import { BasicLoadingPageComponent } from './shared/components/basic-loading-page/basic-loading-page.component'
import { UserService } from './core/http/services/user/user.service'
import { UserStore } from './core/stores/user.store'
import { AuthService } from './core/services/auth/auth.service'
import { takeUntilDestroyed } from '@angular/core/rxjs-interop'
import { BehaviorSubject } from 'rxjs'

@Component({
    selector: 'app-root',
    standalone: true,
    imports: [
        RouterOutlet,
        MatSlideToggle,
        MatProgressBar,
        NgIf,
        AsyncPipe,
        BasicLoadingPageComponent,
    ],
    templateUrl: './app.component.html',
    styleUrl: './app.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AppComponent {
    title = 'WebApp'
    spinner$ = new BehaviorSubject<boolean>(true)
    private readonly progressBarStore = inject(ProgressBarStore)
    loading$ = this.progressBarStore.loading$
    private readonly userService = inject(UserService)
    private readonly userStore = inject(UserStore)
    private readonly auth = inject(AuthService)

    constructor() {
        const accessToken = localStorage.getItem('access')
        const refreshToken = localStorage.getItem('refresh')
        if (accessToken || refreshToken) {
            this.userService
                .getByToken()
                .pipe(takeUntilDestroyed())
                .subscribe({
                    next: (userDto) => {
                        this.userStore.logIn(userDto)
                        this.spinner$.next(false)
                    },
                    error: () => {
                        this.userStore.logOut()
                        this.spinner$.next(false)
                    },
                })
        } else {
            this.auth
                .getRedirectResult()
                .pipe(takeUntilDestroyed())
                .subscribe({
                    next: (result) => {
                        this.userStore.logIn(result)
                        this.spinner$.next(false)
                    },
                    error: () => {
                        this.userStore.logOut()
                        this.spinner$.next(false)
                    },
                })
        }
    }
}
