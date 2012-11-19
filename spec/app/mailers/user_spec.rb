require 'spec_helper'

describe "UserMailer" do
  it "sends an email with user confirmation" do
    user = stub(
      :email => 'john.doe@example.com',
      :first_name => 'John Doe'
    )
    token = stub(:value => 'A1b2C3')

    message = Planner.deliver(:user, :confirm_account, user, token)
    message.to.should == ['john.doe@example.com']
    message.body.should include('A1b2C3')
  end
end
