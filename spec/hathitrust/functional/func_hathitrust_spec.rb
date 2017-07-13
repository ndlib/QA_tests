# frozen_string_literal: true
require 'hathitrust/hathitrust_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)' do
    visit '/'
    find('#login-button').trigger('click')
    find('.button.continue').click
    login_page.completeLogin
    expect(page).to have_link('My Collections')
    expect(page).to have_link('Logout')
  end
end