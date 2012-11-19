Given /^I do not have an account$/ do
  Student.delete_all
end

When /^I enter my information$/ do
  visit '/students/new'

  fill_in 'Name', :with => 'John Doe'
  fill_in 'E-mail', :with => 'john.doe@example.com'
  fill_in 'Password', :with => 'mypassword'
  fill_in 'Confirm', :with => 'mypassword'

  click_on 'Create Account'

  @student = Student.find_by_email('john.doe@example.com')
  @student.should be_a Student
end

When /^I confirm my e-mail address$/ do
  token = @student.email_tokens.last
  UserAuthenticator.confirm_email!(@student, token.value)
end

Then /^I should be able to login$/ do
  visit '/sessions/new'

  fill_in 'E-mail', :with => 'john.doe@example.com'
  fill_in 'Password', :with => 'mypassword'

  click_on 'Login'

  session = @student.sessions.last

  cookie_jar['email'].should == 'john.doe@example.com'
  cookie_jar['session'].should == session.client_value
end
