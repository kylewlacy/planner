require 'spec_helper'

describe 'SessionsController' do
  context "get#new" do
    it "returns a login form" do
      get '/sessions/new'
      last_response.body.should include('Login')
    end
  end

  context "post#create" do
    it "lets users login" do
      token = stub(
        :user => stub(:email => 'john.doe@example.com'),
        :client_value => 'A1b2C3'
      )
      UserAuthenticator.should_receive(:login!).with(
        :email => 'john.doe@example.com',
        :password => 'password'
      ) { token }

      post '/sessions', :user => {
        :email => 'john.doe@example.com', :password => 'password'
      }

      rack_mock_session.cookie_jar['session'].should == 'A1b2C3'
      rack_mock_session.cookie_jar['email'].should == 'john.doe@example.com'

      last_response.should be_redirect
    end

    it "only lets users login with valid credentials" do
      UserAuthenticator.stub(:login!).and_raise UserAuthenticator::WrongPassword
      post '/sessions', :user => {
        :email => 'john.doe@example.com', :password => 'password'
      }

      last_response.status.should == 401
    end

    it "does not let nonexistant users login" do
      UserAuthenticator.stub(:login!).and_raise User::UserDoesNotExist
      post '/sessions', :user => {
        :email => 'john.doe@example.com', :password => 'password'
      }

      last_response.status.should == 401
    end
  end

  context "delete#destroy" do
    it "lets users log out" do
      header 'User-Agent', 'Chrome'
      set_cookie 'email=john.doe@example.com'
      set_cookie 'token=A1b2C3'

      user = stub
      UserAuthenticator.should_receive(:authenticate_client!) do |agent, cookies|
        agent.should == 'Chrome'
        cookies.to_hash.should == {
          'email' => 'john.doe@example.com',
          'token' => 'A1b2C3'
        }

        user
      end

      UserTokenRepository.should_receive(:destroy_session!).with(
        user, 'A1b2C3'
      )

      delete '/sessions/A1b2C3'

      cookies = rack_mock_session.cookie_jar.to_hash
      cookies['email'].should be_empty
      cookies['token'].should be_empty
    end
  end
end
