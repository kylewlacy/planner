Given /^I have an account$/ do
  @student = Student.create_account!(
    :name => 'John Doe',
    :email => 'john.doe@example.com',
    :password => 'mypassword'
  )
  token = @student.email_tokens.last

  UserAuthenticator.confirm_email!(@student, token.value)
end

Given /^I'm logged in$/ do
  UserAuthenticator.login!(
    :email => 'john.doe@example.com',
    :password => 'mypassword'
  )
end

When /^I enter my course information$/ do
  @course = @student.add_course!(
    :name => 'Math',
    :data => {
      :room => '101'
    }
  )
end

When /^I enter my schedule for the course$/ do
  @student.add_schedule!(
    :default,
    :'1' => {
      :course => @course,
      :start => WallClock.new(9, 00),
      :end => WallClock.new(10, 00)
    }
  )
end

Then /^I should have the course in my schedule$/ do
  @student.default_schedule.courses.should include(@course)
end
