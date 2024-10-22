import { ChangeDetectionStrategy, Component } from '@angular/core'
import { RouterOutlet } from '@angular/router'
import { AsyncPipe, NgIf } from '@angular/common'
import { BasicLoadingPageComponent } from '../../shared/components/basic-loading-page/basic-loading-page.component'

@Component({
    selector: 'app-auth-feature',
    standalone: true,
    imports: [RouterOutlet, NgIf, AsyncPipe, BasicLoadingPageComponent],
    templateUrl: './auth-feature.component.html',
    styleUrl: './auth-feature.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AuthFeatureComponent {
}
