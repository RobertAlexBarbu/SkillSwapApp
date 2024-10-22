import { Pipe, PipeTransform } from '@angular/core'
import { UserState } from '../../../core/stores/user.store'

@Pipe({
    name: 'isConfigured',
    standalone: true,
})
export class IsConfiguredPipe implements PipeTransform {
    transform(value: UserState): boolean {
        return value.user.configured
    }
}
