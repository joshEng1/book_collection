# spec/system/create_task_spec.rb
#require "application_system_test_case"
require 'rails_helper'

  RSpec.describe 'Creating a task', type: :feature do
    scenario 'valid inputs' do
#      visit tasks_path
#      expect(page).to have_content('Amazing List of Tasks')

      visit new_task_path
#      expect(page).to have_content('Name')
#      expect(page).to have_content('Position')
#      expect(page).to have_content('Completed')
#      expect(page).to have_content('Description')
#      expect(page).to have_content('Yuck')
      fill_in "task[name]", with: "Yahoo2"
      click_on 'Create Task'
      visit tasks_path
      expect(page).to have_content('Yahoo2')
    end
end
