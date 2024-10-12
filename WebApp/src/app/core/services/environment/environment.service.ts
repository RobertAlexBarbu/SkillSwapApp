import { Injectable } from '@angular/core'
import { environment } from '../../../../environments/environment'
import { IEnvironment } from '../../../../environments/environment.interface'

@Injectable({
    providedIn: 'root',
})
export class EnvironmentService {
    getBaseUrl() {
        return environment.baseUrl
    }
    getRedirectAuth() {
        return environment.redirectAuth
    }
}
