import { ComponentFixture, TestBed } from '@angular/core/testing'

import { ConfigurePageComponent } from './configure-page.component'

describe('ConfigurePageComponent', () => {
    let component: ConfigurePageComponent
    let fixture: ComponentFixture<ConfigurePageComponent>

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [ConfigurePageComponent],
        }).compileComponents()

        fixture = TestBed.createComponent(ConfigurePageComponent)
        component = fixture.componentInstance
        fixture.detectChanges()
    })

    it('should create', () => {
        expect(component).toBeTruthy()
    })
})
