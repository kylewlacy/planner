require './lib/user_token_repository.rb'

describe UserTokenRepository do
  context "#generate_token_value" do
    it "generates random token values" do
      value = UserTokenRepository.generate_token_value
      value.should be_a(String)
    end

    it "only generates strings with a length greater than 2" do
      expect do
        UserTokenRepository.generate_token_value(2)
      end.to raise_error ArgumentError

      UserTokenRepository.generate_token_value(3).length.should == 3
    end
  end

  it "generates tokens for users" do
    EmailToken.stub(:create!) { stub }
    Session.stub(:create!) { stub }

    email_tokens = stub
    sessions = stub
    user = stub(
      :email_tokens => email_tokens,
      :sessions => sessions
    )

    email_tokens.should_receive(:<<).once
    sessions.should_receive(:<<).once

    UserTokenRepository.add_email_token(user)
    UserTokenRepository.add_session(user)
  end

  context "#destroy_session!" do
    it "destroys sessions for users" do
      sessions = stub(:empty? => false)
      sessions.should_receive(:destroy_all!)
      sessions.should_receive(:where).with(
        :client_value => 'A1b2C3'
      ) { sessions }

      user = stub(:sessions => sessions)

      UserTokenRepository.destroy_session!(user, 'A1b2C3')
    end
  end
end
