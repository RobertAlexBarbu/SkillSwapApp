import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { SingleImageUpload } from '../../shared/components/single-image-upload/single-image-upload'
import { MatIcon } from '@angular/material/icon'
import { MatLabel, MatSuffix } from '@angular/material/form-field'
import { UserStore } from '../../core/stores/user.store'
import { AsyncPipe, NgIf } from '@angular/common'

@Component({
    selector: 'app-feature1',
    standalone: true,
  imports: [SingleImageUpload, MatIcon, MatLabel, MatSuffix, AsyncPipe, NgIf],
    templateUrl: './feature1.component.html',
    styleUrl: './feature1.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Feature1Component {
  private readonly userStore = inject(UserStore)
  user$ = this.userStore.user$

    file: File | null = null
    onFileUpload(event: File | null) {
        this.file = event
        console.log(this.file)
    }


}
