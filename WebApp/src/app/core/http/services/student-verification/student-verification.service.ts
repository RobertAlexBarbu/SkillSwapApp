import { inject, Injectable } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { EnvironmentService } from '../../../services/environment/environment.service'
import { VerificationRequestDto } from '../../dto/verification-request/verification-request.dto'
import { Observable } from 'rxjs'
import { CreateVerificationRequestDto } from '../../dto/verification-request/create-verification-request.dto'

@Injectable({
  providedIn: 'root'
})
export class StudentVerificationService {
    private readonly http = inject(HttpClient);
    private readonly environment = inject(EnvironmentService);
    private readonly baseUrl;

    constructor() {
        this.baseUrl = this.environment.getBaseUrl() + '/StudentVerification';
    }
    
    public createVerificationRequest(createVerificationRequestDto: CreateVerificationRequestDto) {
        return this.http.post(`${this.baseUrl}/CreateVerificationRequest`, createVerificationRequestDto);
    }
    
    public getVerificationRequests(): Observable<VerificationRequestDto[]> {
        return this.http.get<VerificationRequestDto[]>(`${this.baseUrl}/GetVerificationRequests`);
    }
    
    public verifyAccount(id: string) {
        return this.http.patch(`${this.baseUrl}/VerifyAccount/${id}`, {});
    }
}
