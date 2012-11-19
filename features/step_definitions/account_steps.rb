Given /^I do not have an account$/ do
  Student.delete_all
end

When /^I enter my information$/ do
  Student.create_account!(
    :name => 'John Doe',
    :email => 'john.doe@example.com',
    :password => 'badpassword'
  )
end

When /^I confirm my e-mail address$/ do
  student = Student.find_by_email('john.doe@example.com')
  token = student.email_tokens.last
  UserAuthenticator.confirm_email!(student, token.value)
end

Then /^I should be able to login$/ do
  UserAuthenticator.login!(
    :email => 'john.doe@example.com',
    :password => 'badpassword'
  )
end
