require 'spec_helper'

describe Token do
  it "can belong to a user" do
    token = Token.create(:value => 'A1b2C3')
    user = User.create!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'idontcare'
    )
    user.tokens << token

    user.tokens.should == [token]
    token.user.should == user
  end

  it "must have a value" do
    expect do
      Token.create
    end.not_to raise_error ActiveRecord::RecordInvalid
  end
end
