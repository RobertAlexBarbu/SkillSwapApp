import { ChangeDetectionStrategy, Component } from '@angular/core'
import { SingleImageUpload } from '../../shared/components/single-image-upload/single-image-upload'

@Component({
    selector: 'app-feature1',
    standalone: true,
    imports: [SingleImageUpload],
    templateUrl: './feature1.component.html',
    styleUrl: './feature1.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Feature1Component {
    file: File | null = null
    onFileUpload(event: File | null) {
        this.file = event
        console.log(this.file)
    }
}
