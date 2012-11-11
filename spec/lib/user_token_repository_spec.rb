require './lib/user_token_repository.rb'

describe UserTokenRepository do
  before do
    @token_classes_are_temp = !(defined?(EmailToken) && defined?(AuthToken))
    if @token_classes_are_temp
      EmailToken ||= Class.new
      AuthToken ||= Class.new
    end
  end

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
    AuthToken.stub(:create!) { stub }
    tokens = stub
    user = stub(:tokens => tokens)

    tokens.should_receive(:<<).exactly(2).times
    email_token = UserTokenRepository.add_email_token(user)
    auth_token = UserTokenRepository.add_auth_token(user)
  end

  after do
    if @token_classes_are_temp
      Object.send(:remove_const, :EmailToken)
      Object.send(:remove_const, :AuthToken)
    end
  end
end
