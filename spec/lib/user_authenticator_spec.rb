require './lib/user_authenticator.rb'

describe UserAuthenticator do
  context "#confirm_email!" do
    it "confirms users' e-mails" do
      token = stub
      tokens = stub(:where => [token])
      user = stub(:tokens => tokens)

      tokens.should_receive(:where).with(
        :value => 'a1B2c3',
        :type => 'EmailToken'
      )
      token.should_receive(:destroy)

      UserAuthenticator.confirm_email!(user, 'a1B2c3')
   end

    it "raises an error with an invalid email token" do
      tokens = stub(:where => [])
      user = stub(:tokens => tokens)

      expect do
        UserAuthenticator.confirm_email!(user, 'a1B2c3')
      end.to raise_error UserAuthenticator::InvalidEmailToken
    end
  end

  context "#login!" do
    it "logs in users with a proper password" do
      tokens = stub
      user = stub(:password => 'asdf', :tokens => tokens)
      User.stub(:find_by_email) { user }
      UserTokenRepository.should_receive(:add_auth_token)

      UserAuthenticator.login!(
        :email => 'john.doe@example.com',
        :password => 'asdf'
      )
    end

    it "raises an error without a proper password" do
      tokens = stub
      user = stub(:password => 'asdf', :tokens => tokens)
      User.stub(:find_by_email) { user }
      UserTokenRepository.should_not_receive(:add_auth_token)

      expect do
        UserAuthenticator.login!(
          :email => 'john.doe@example.com',
          :password => 'jkl'
        )
      end.to raise_error UserAuthenticator::WrongPassword
    end
  end

  context "#authenticate!" do
    it "authenticates users currently logged in" do
      user = stub(
        :email => 'john@example.com',
        :password => 'somepassword'
      )
      User.stub(:find_by_email) {user}

      client_string = UserAuthenticator.generate_client_string(user, 'Chrome')

      UserAuthenticator.authenticate_client!(
        'Chrome',
        :email => 'john@example.com',
        :token => client_string
      ).should == user
    end

    it "raises an error for an inauthentic client" do
      user = stub(
        :email => 'john@example.com',
        :password => 'somepassword'
      )
      User.stub(:find_by_email) {user}

      client_string = UserAuthenticator.generate_client_string(user, 'Chrome')

      expect do
        UserAuthenticator.authenticate_client!(
          'Safari',
          :email => 'john@example.com',
          :token => client_string
        )
      end.to raise_error UserAuthenticator::InvalidClient
    end
  end

  context "#generate_client_string" do
    it "generates unique strings for clients" do
      user = stub(:email => 'john@example.com', :password => 'bad')
      main_string = UserAuthenticator.generate_client_string(user, 'Chrome')
      second_string = UserAuthenticator.generate_client_string(user, 'Chrome')

      user = stub(:email => 'jade@example.com', :password => 'bad')
      email_string = UserAuthenticator.generate_client_string(user, 'Chrome')

      user = stub(:email => 'john@example.com', :password => 'good')
      pass_string = UserAuthenticator.generate_client_string(user, 'Chrome')

      user = stub(:email => 'john@example.com', :password => 'bad')
      ua_string = UserAuthenticator.generate_client_string(user, 'Safari')

      main_string.should_not == email_string
      main_string.should_not == pass_string
      main_string.should_not == ua_string
    end
  end
end
