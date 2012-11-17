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
    tokens = stub
    user = stub(:tokens => tokens)

    tokens.should_receive(:<<).exactly(2).times
    email_token = UserTokenRepository.add_email_token(user)
    session = UserTokenRepository.add_session(user)
  end
end
