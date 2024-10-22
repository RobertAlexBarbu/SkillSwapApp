import { Pipe, PipeTransform } from '@angular/core'
import { UserState } from '../../../core/stores/user.store'

@Pipe({
    name: 'isAuth',
    standalone: true,
})
export class IsAuthPipe implements PipeTransform {
    transform(value: UserState): boolean {
        return value.loggedIn
    }
}
