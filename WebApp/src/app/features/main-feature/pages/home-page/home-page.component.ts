import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { UserStore } from '../../../../core/stores/user.store'
import { AsyncPipe, JsonPipe, NgIf } from '@angular/common'
import { MatButton } from '@angular/material/button'
import { Router } from '@angular/router'
import { TestService } from '../../../../core/http/services/test/test.service'
import { BehaviorSubject } from 'rxjs'

@Component({
    selector: 'app-home-page',
    standalone: true,
    imports: [AsyncPipe, JsonPipe, NgIf, MatButton],
    templateUrl: './home-page.component.html',
    styleUrl: './home-page.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HomePageComponent {}
