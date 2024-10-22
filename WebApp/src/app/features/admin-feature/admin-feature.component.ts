import { ChangeDetectionStrategy, Component } from '@angular/core'

@Component({
    selector: 'app-admin-feature',
    standalone: true,
    imports: [],
    templateUrl: './admin-feature.component.html',
    styleUrl: './admin-feature.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AdminFeatureComponent {}
