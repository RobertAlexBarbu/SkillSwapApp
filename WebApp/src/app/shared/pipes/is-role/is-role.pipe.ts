import { Pipe, PipeTransform } from '@angular/core'
import { UserState } from '../../../core/stores/user.store'
import { Role } from '../../enums/Role'

@Pipe({
    name: 'isRole',
    standalone: true,
})
export class IsRolePipe implements PipeTransform {
    transform(value: UserState, role: Role): boolean {
        return value.user.role === role
    }
}
