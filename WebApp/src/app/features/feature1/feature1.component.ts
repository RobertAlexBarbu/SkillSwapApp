import { ChangeDetectionStrategy, Component, inject } from '@angular/core'
import { SingleImageUpload } from '../../shared/components/single-image-upload/single-image-upload'
import { MatIcon } from '@angular/material/icon'
import { MatLabel, MatSuffix } from '@angular/material/form-field'
import { UserStore } from '../../core/stores/user.store'
import { AsyncPipe, NgIf } from '@angular/common'
import { MatIconButton } from '@angular/material/button'
import { Router } from '@angular/router'

@Component({
    selector: 'app-feature1',
    standalone: true,
  imports: [SingleImageUpload, MatIcon, MatLabel, MatSuffix, AsyncPipe, NgIf, MatIconButton],
    templateUrl: './feature1.component.html',
    styleUrl: './feature1.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class Feature1Component {
  private readonly router = inject(Router)
  private readonly userStore = inject(UserStore)
  user$ = this.userStore.user$

    file: File | null = null
    onFileUpload(event: File | null) {
        this.file = event
        console.log(this.file)
    }


  redirectToEditPage() {
    return this.router.navigate(['private/main/edit-profile'])
  }
}
