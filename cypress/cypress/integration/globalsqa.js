/// <reference types = "cypress" />

describe('GlobalSqa Form Test', () => {
    Cypress.on('uncaught:exception', (err, runnable) => {
        return false;
    })
    it('Submiting form with required field filled', () => {
        cy.visit('https://www.globalsqa.com/samplepagetest/')
        cy.get('input[class="name"]').type('Jerome')
        cy.get('input[class="email"]').type('jerome@hmail.com')
        cy.get('select[class="select"]').select('3-5')
        cy.get('textarea[class="textarea"]').type('Hello, World.')
        cy.get('button[type="submit"]').click()
        cy.get('blockquote[class="contact-form-submission"]').contains('Comment: Hello, World.')
    })

    it('Submiting empty form', () => {
        cy.visit('https://www.globalsqa.com/samplepagetest/')
        cy.get('button[type="submit"]').click()
        cy.get('input:invalid').should('have.length', 2)
cy.get('#g2599-name').then(($input) => {
  expect($input[0].validationMessage).to.eq('Заполните это поле.')
})
    })
    
})