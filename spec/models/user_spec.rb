require 'spec_helper'

describe User do
  context "when the user doesn't have an account" do
    it "can create new accounts" do
      User.create_account!(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      )
    end

    it "only lets users create one account" do
      User.create_account!(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      )

      expect do
        User.create_account!(
          :name => 'John Doe',
          :email => 'john.doe@example.com',
          :password => 'somepassword'
        )
      end.to raise_error User::EmailAlreadyUsed
    end

    it "must have the required fields" do
      expect do
        User.create_account!({})
      end.to raise_error ActiveRecord::RecordInvalid
    end

    it "creates a cofirmation email token for users" do
      user = User.create_account!(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'badpass'
      )
      user.tokens.where(:type => 'EmailToken').should_not be_empty
    end

    it "saves users' names in the database" do
      user = User.create_account!(
        :name => 'John Jimmy Doe',
        :email => 'john.jimmy.doe@example.com',
        :password => 'terriblepassword'
      )

      user.name.should == 'John Jimmy Doe'
      user.first_name.should == 'John'
      user.last_name.should == 'Jimmy Doe'
    end

    it "encrypts users' passwords" do
      user = User.create_account!(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'badpassword'
      )

      user.password.should == 'badpassword'
      user.password.to_s.should_not == 'badpassword'
      user.password_hash.should_not == 'badpassword'
      user.password.should be_a BCrypt::Password
    end

    it "raises an error for nonexistent users" do
      expect do
        User.find_by_email!('some.user@gmail.com')
      end.to raise_error User::UserDoesNotExist
    end
  end

  context "when the user has an account" do
    before :each do
      UserTokenRepository.stub(:add_email_token)

      @user = User.create_account!(
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      )
    end

    context "#tokens" do
      it "returns the tokens belonging to a user" do
        3.times do
          @user.tokens << Token.create!(:value => 'A1b2C3')
        end

        @user.tokens.count.should == 3
        @user.tokens.each do |token|
          token.should be_a Token
        end

        @user.tokens.destroy_all
        @user.tokens.count.should == 0
      end
    end

    context "#sessions" do
      it "returns the sessions belonging to a user" do
        3.times do
          @user.sessions << Session.create!(
            :value => 'A1b2C3', :client_value => 'a1B2c3'
          )
        end

        @user.sessions.count.should == 3
        @user.tokens.count.should == 3
        @user.email_tokens.count.should == 0

        @user.sessions.destroy_all
        @user.sessions.count.should ==0
      end
    end

    context "#email_tokens" do
      it "returns the email tokens belonging to a user" do
        3.times do
          @user.email_tokens << EmailToken.create!(:value => 'A1b2C3')
        end

        @user.email_tokens.count.should == 3
        @user.tokens.count.should == 3
        @user.sessions.count.should == 0

        @user.email_tokens.destroy_all
        @user.email_tokens.count.should == 0
      end
    end

    context "#add_course!" do
      it "adds courses for a user" do
        @user.add_course!(
          :name => 'Math',
          :data => {
            :room => '101'
          }
        )

        @user.courses.count.should == 1
        @user.courses.first.name.should == 'Math'
        @user.courses.first.data[:room].should == '101'
      end
    end
  end
end
