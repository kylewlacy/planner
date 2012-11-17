Given /^I do not have an account$/ do
  User.delete_all
end

When /^I enter my information$/ do
  User.create_account(
    :name => 'John Doe',
    :email => 'john.doe@example.com',
    :password => 'badpassword'
  )
end

When /^I confirm my e-mail address$/ do
  user = User.find_by_email('john.doe@example.com')
  token = user.tokens.where(:type => 'EmailToken').last
  UserAuthenticator.confirm_email!(user, token.value)
end

Then /^I should be able to login$/ do
  UserAuthenticator.login!(
    :email => 'john.doe@example.com',
    :password => 'badpassword')
end
