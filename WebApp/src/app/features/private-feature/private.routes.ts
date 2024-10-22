import { Routes } from '@angular/router'
import { isConfiguredGuard } from '../../core/guards/is-configured/is-configured.guard'
import { isAuthGuard } from '../../core/guards/is-auth/is-auth.guard'
import { isNotAuthGuard } from '../../core/guards/is-not-auth/is-not-auth.guard'

export const privateRoutes: Routes = [
    {
        path: '',
        loadComponent: () =>
            import('./private-feature.component').then(
                (m) => m.PrivateFeatureComponent
            ),
        children: [
            {
                path: 'auth',
                canActivate: [isNotAuthGuard],
                loadChildren: () =>
                    import('../auth-feature/auth.routes').then(
                        (m) => m.authRoutes
                    ),
            },
            {
                path: 'main',
                canActivate: [isAuthGuard, isConfiguredGuard],
                loadChildren: () =>
                    import('../main-feature/main.routes').then(
                        (m) => m.mainRoutes
                    ),
            },
            {
                path: 'configure',
                canActivate: [isAuthGuard],
                loadComponent: () =>
                    import(
                        './pages/configure-page/configure-page.component'
                    ).then((m) => m.ConfigurePageComponent),
            },
            {
                path: '**',
                pathMatch: 'full',
                redirectTo: 'main',
            },
        ],
    },
]
