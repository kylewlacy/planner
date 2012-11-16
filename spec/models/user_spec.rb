require 'spec_helper'

describe User do
  context "when the user doesn't have an account" do
    it "can create new accounts" do
      User.create_account(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      )
    end

    it "only lets users create one account" do
      User.create_account(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      )

      expect do
        User.create_account(
          :name => 'John Doe',
          :email => 'john.doe@example.com',
          :password => 'somepassword'
        )
      end.to raise_error User::EmailAlreadyUsed
    end

    it "creates a cofirmation email token for users" do
      user = User.create_account(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'badpass'
      )
      user.tokens.where(:type => 'EmailToken').should_not be_empty
    end

    it "saves users' names in the database" do
      user = User.create_account(
        :name => 'John Jimmy Doe',
        :email => 'john.jimmy.doe@example.com',
        :password => 'terriblepassword'
      )

      user.name.should == 'John Jimmy Doe'
      user.first_name.should == 'John'
      user.last_name.should == 'Jimmy Doe'
    end

    it "encrypts users' passwords" do
      user = User.create_account(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'badpassword'
      )

      user.password.should == 'badpassword'
      user.password.to_s.should_not == 'badpassword'
      user.password_hash.should_not == 'badpassword'
      user.password.should be_a BCrypt::Password
    end
  end
end
