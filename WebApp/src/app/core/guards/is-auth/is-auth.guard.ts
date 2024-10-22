import { CanActivateFn, Router } from '@angular/router'
import { inject } from '@angular/core'
import { UserStore } from '../../stores/user.store'
import { of, switchMap } from 'rxjs'

export const isAuthGuard: CanActivateFn = (route, state) => {
    console.log('IsAuthGuard runs')
    const userStore = inject(UserStore)
    const router = inject(Router)
    return userStore.state$.pipe(
        switchMap((state) => {
            if (state.loggedIn) {
                return of(true)
            } else {
                return of(router.parseUrl('/private/auth'))
            }
        })
    )
}
