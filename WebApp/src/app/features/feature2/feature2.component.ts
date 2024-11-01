import { ChangeDetectionStrategy, Component } from '@angular/core'
import { SingleImageUpload } from '../../shared/components/single-image-upload/single-image-upload'
import { MatIcon } from '@angular/material/icon'
import { MatFormField, MatFormFieldModule, MatLabel } from '@angular/material/form-field'
import { FormsModule } from '@angular/forms'
import { MatInputModule } from '@angular/material/input'

@Component({
    selector: 'app-feature2',
    standalone: true,
  imports: [
    SingleImageUpload,
    MatIcon,
    MatInputModule,
    MatFormFieldModule,
    FormsModule
  ],
    templateUrl: './feature2.component.html',
    styleUrl: './feature2.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Feature2Component {
  file: File | null = null
  onFileUpload(event: File | null) {
    this.file = event
    console.log(this.file)
  }
}
