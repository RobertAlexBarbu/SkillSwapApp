import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-edit-profile',
  standalone: true,
  imports: [],
  templateUrl: './edit-profile.component.html',
  styleUrl: './edit-profile.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class EditProfileComponent {

}
