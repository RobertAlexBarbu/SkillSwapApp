import { Routes } from '@angular/router'
import { isAuthGuard } from '../../core/guards/is-auth/is-auth.guard'
import { isRoleGuard } from '../../core/guards/is-role/is-role.guard'
import { Roles } from '../../shared/enums/Roles'

export const mainRoutes: Routes = [
    {
        path: '',
        loadComponent: () =>
            import('./main-feature.component').then(
                (m) => m.MainFeatureComponent
            ),
        children: [
            {
                path: '',
                loadComponent: () =>
                    import('./pages/home-page/home-page.component').then(
                        (m) => m.HomePageComponent
                    ),
            },
            {
                path: 'feature1',
                loadComponent: () =>
                    import('../feature1/feature1.component').then(
                        (m) => m.Feature1Component
                    ),
            },
            {
                path: 'feature2',
                loadComponent: () =>
                    import('../feature2/feature2.component').then(
                        (m) => m.Feature2Component
                    ),
            },
            {
                path: 'debug',
                loadComponent: () =>
                    import('../debug-feature/debug-feature.component').then(
                        (m) => m.DebugFeatureComponent
                    ),
            },
            {
                path: 'edit-profile',
                loadComponent: () =>
                  import('../edit-profile/edit-profile.component').then(
                    (m) => m.EditProfileComponent
                  ),
              },
            {
                path: 'admin',
                canActivate: [
                    isAuthGuard,
                    isRoleGuard(Roles.Admin, '/private/main'),
                ],
                loadComponent: () =>
                    import('../admin-feature/admin-feature.component').then(
                        (m) => m.AdminFeatureComponent
                    ),
            },
        ],
    },
]
