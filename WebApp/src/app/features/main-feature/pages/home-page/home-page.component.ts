import { ChangeDetectionStrategy, Component } from '@angular/core'
import { AsyncPipe, JsonPipe, NgIf } from '@angular/common'
import { MatButton } from '@angular/material/button'

@Component({
    selector: 'app-home-page',
    standalone: true,
    imports: [AsyncPipe, JsonPipe, NgIf, MatButton],
    templateUrl: './home-page.component.html',
    styleUrl: './home-page.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HomePageComponent {}
