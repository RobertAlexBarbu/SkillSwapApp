import { Routes } from '@angular/router'

export const routes: Routes = [
    {
        path: 'private',
        loadChildren: () =>
            import('./features/private-feature/private.routes').then(
                (x) => x.privateRoutes
            ),
    },
    {
        path: 'public',
        loadChildren: () =>
            import('./features/public-feature/public.routes').then(
                (x) => x.publicRoutes
            ),
    },
    {
        path: '**',
        pathMatch: 'full',
        redirectTo: 'private',
    },
]
