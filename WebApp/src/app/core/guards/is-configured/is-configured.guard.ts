import { CanActivateFn, Router } from '@angular/router'
import { inject } from '@angular/core'
import { UserStore } from '../../stores/user.store'
import { of, switchMap } from 'rxjs'

export const isConfiguredGuard: CanActivateFn = (route, state) => {
    console.log('IsConfiguredGuard runs')
    const userStore = inject(UserStore)
    const router = inject(Router)
    return userStore.configured$.pipe(
        switchMap((state) => {
            if (state) {
                return of(true)
            } else {
                return of(router.parseUrl('/private/configure'))
            }
        })
    )
}
