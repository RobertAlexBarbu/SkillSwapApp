import { ChangeDetectionStrategy, Component } from '@angular/core'
import { RouterOutlet } from '@angular/router'

@Component({
    selector: 'app-private-feature',
    standalone: true,
    imports: [RouterOutlet],
    templateUrl: './private-feature.component.html',
    styleUrl: './private-feature.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PrivateFeatureComponent {
    // private readonly userService = inject(UserService)
    // private readonly userStore = inject(UserStore)
    // private readonly auth = inject(AuthService)
    //
    // constructor() {
    //     const accessToken = localStorage.getItem('access')
    //     const refreshToken = localStorage.getItem('refresh')
    //     if (accessToken || refreshToken) {
    //         this.userService
    //             .getByToken()
    //             .pipe(takeUntilDestroyed())
    //             .subscribe({
    //                 next: (userDto) => {
    //                     console.log(userDto)
    //                     this.userStore.logIn(userDto)
    //                 },
    //                 error: () => {
    //                     this.userStore.logOut()
    //                 },
    //             })
    //     } else {
    //         this.auth
    //             .getRedirectResult()
    //             .pipe(takeUntilDestroyed())
    //             .subscribe({
    //                 next: (result) => {
    //                     this.userStore.logIn(result)
    //                 },
    //                 error: () => {
    //                     this.userStore.logOut()
    //                 },
    //             })
    //     }
    // }
}
