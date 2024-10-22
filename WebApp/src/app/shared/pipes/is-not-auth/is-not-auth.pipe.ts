import { Pipe, PipeTransform } from '@angular/core'
import { UserState } from '../../../core/stores/user.store'

@Pipe({
    name: 'isNotAuth',
    standalone: true,
})
export class IsNotAuthPipe implements PipeTransform {
    transform(value: UserState): boolean {
        return !value.loggedIn
    }
}
