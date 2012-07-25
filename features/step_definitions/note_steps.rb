# Declarative steps for notes related features

Given /^I am on the Anotar home page$/ do
  visit notes_path
  page.should have_content 'Write a note!'
end

Given /^I am not logged in$/ do
  page.should have_button 'Login'
end

When /^I add a new note "(.*?)"$/ do |text|
  fill_in 'text', :with => text
  click_button 'Add note'
end

Then /^I should see the Anotar home page$/ do
  page.should have_content 'Write a note!'
end

Then /^the notice "(.*?)"$/ do |notice|
  page.should have_content notice
end

Given /^I'm logged in as "(.*?)"$/ do |username|
  @user = User.create(:username => username, :password => 's3cr3t',
    :email => username + '@email.com')
  visit users_login_path :login => @user.username, :password => @user.password
  page.should have_content('Hello, ' + @user.username)
end