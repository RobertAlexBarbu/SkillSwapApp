import {
    ChangeDetectionStrategy,
    Component,
    EventEmitter,
    Output,
} from '@angular/core'
import { NgIf } from '@angular/common'
import { GetFileUrlPipe } from '../../pipes/get-file-url/get-file-url.pipe'
import { MatIcon } from '@angular/material/icon'
import { MatButton, MatIconButton } from '@angular/material/button'
import { MatFormField, MatInput } from '@angular/material/input'
import { MatLabel } from '@angular/material/form-field'

@Component({
    selector: 'app-single-image-upload',
    standalone: true,
    imports: [
        NgIf,
        GetFileUrlPipe,
        MatIcon,
        MatIconButton,
        MatButton,
        MatInput,
        MatFormField,
        MatLabel,
    ],
    templateUrl: './single-image-upload.html',
    styleUrl: './single-image-upload.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SingleImageUpload {
    @Output() onUploadChange: EventEmitter<File | null> =
        new EventEmitter<File | null>()
    file: File | null = null
    onFileInputChange(event: Event) {
        const eventTarget = event.target
        if (eventTarget) {
            const fileInput = eventTarget as HTMLInputElement
            if (fileInput.files && fileInput.files.length > 0) {
                this.file = fileInput.files[0]
                this.onUploadChange.emit(fileInput.files[0])
            } else {
                this.file = null
                this.onUploadChange.emit(null)
            }
        }
    }

    deleteFile(fileInput: HTMLInputElement) {
        fileInput.value = ''
        this.file = null
        this.onUploadChange.emit(null)
    }
}
