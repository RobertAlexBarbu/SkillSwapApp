import { CanActivateFn, Router } from '@angular/router'
import { inject } from '@angular/core'
import { UserStore } from '../../stores/user.store'
import { of, switchMap } from 'rxjs'

export const isNotAuthGuard: CanActivateFn = (route, state) => {
    console.log('IsNotAuthGuard runs')
    const userStore = inject(UserStore)
    const router = inject(Router)
    return userStore.state$.pipe(
        switchMap((state) => {
            if (state.loggedIn) {
                return of(router.parseUrl('/private/main'))
            } else {
                return of(true)
            }
        })
    )
}
