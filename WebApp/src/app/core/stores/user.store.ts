import { ComponentStore } from '@ngrx/component-store'
import { UserDto } from '../http/dto/user/user.dto'
import { Injectable } from '@angular/core'

export interface UserState {
    user: UserDto
    loggedIn: boolean
}

const initialUserData: UserDto = {
    email: '',
    id: '',
    provider: '',
    role: '',
    createdAt: new Date(),
    configured: false,
}

@Injectable({
    providedIn: 'root',
})
export class UserStore extends ComponentStore<UserState> {
    loggedIn$ = this.select((state) => state.loggedIn)
    configured$ = this.select((state) => state.user.configured)
    user$ = this.select((state) => state.user)
    role$ = this.select((state) => state.user.role)
    public configure = this.updater((state, value: UserDto) => {
        return {
            user: value,
            loggedIn: state.loggedIn,
        }
    })

    logIn(value: UserDto) {
        this.setState({
            user: value,
            loggedIn: true,
        })
    }

    logOut() {
        this.setState({
            user: initialUserData,
            loggedIn: false,
        })
    }
}
