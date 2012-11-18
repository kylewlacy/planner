require 'spec_helper'

describe Token do
  it "can belong to a user" do
    token = Token.create
    user = User.create
    user.tokens << token

    user.tokens.should == [token]
    token.user.should == user
  end
end
