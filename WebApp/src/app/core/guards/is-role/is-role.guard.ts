import { CanActivateFn, Router } from '@angular/router'
import { Role } from '../../../shared/enums/Role'
import { inject } from '@angular/core'
import { UserStore } from '../../stores/user.store'
import { of, switchMap } from 'rxjs'

export const isRoleGuard = (role: Role, redirectUrl: string): CanActivateFn => {
    const isRoleGuardFn: CanActivateFn = (route, state) => {
        console.log('IsRoleGuard runs')
        const userStore = inject(UserStore)
        const router = inject(Router)
        return userStore.role$.pipe(
            switchMap((r) => {
                if (r === role) {
                    return of(true)
                } else {
                    return of(router.parseUrl(redirectUrl))
                }
            })
        )
    }
    return isRoleGuardFn
}
