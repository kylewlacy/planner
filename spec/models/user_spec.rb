require 'spec_helper'

describe User do
  context "when the user doesn't have an account" do
    it "allows users to create accounts" do
      User.create_account(
        'John', 'Doe', 'john.doe@example.com', 'somepassword'
      )
    end

    it "only lets users create one account" do
      User.create_account(
        'John', 'Doe', 'john.doe@example.com', 'somepassword'
      )
      expect do
        User.create_account(
          'John', 'Doe', 'john.doe@example.com', 'pass'
        )
      end.to raise_error User::EmailAlreadyUsed
    end

    it "creates a cofirmation email token for users" do
      user = User.create_account(
        'John', 'Doe', 'john.doe@example.com', 'badpass'
      )
      user.tokens.where(:type => 'EmailToken').should_not be_empty
    end

    it "encrypts users' passwords" do
      user = User.create_account(
        'John', 'Doe', 'john.doe@example.com', 'password'
      )

      user.password.should == 'password'
      user.password.to_s.should_not == 'password'
      user.password_hash.should_not == 'password'
    end
  end
end
