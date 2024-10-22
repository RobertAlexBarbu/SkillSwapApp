import {
    ChangeDetectionStrategy,
    Component,
    DestroyRef,
    inject,
} from '@angular/core'
import { MatButton } from '@angular/material/button'
import { UserStore } from '../../../../core/stores/user.store'
import { UserService } from '../../../../core/http/services/user/user.service'
import { BehaviorSubject } from 'rxjs'
import { takeUntilDestroyed } from '@angular/core/rxjs-interop'
import { Router } from '@angular/router'
import { AsyncPipe } from '@angular/common'

@Component({
    selector: 'app-configure-page',
    standalone: true,
    imports: [MatButton, AsyncPipe],
    templateUrl: './configure-page.component.html',
    styleUrl: './configure-page.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ConfigurePageComponent {
    disabled$ = new BehaviorSubject<boolean>(false)
    private readonly userService = inject(UserService)
    private readonly userStore = inject(UserStore)
    private readonly destroyRef = inject(DestroyRef)
    private readonly router = inject(Router)

    configure() {
        this.disabled$.next(true)
        this.userService
            .configureByToken()
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe({
                next: (value) => {
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
