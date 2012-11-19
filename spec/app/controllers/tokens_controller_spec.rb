require 'spec_helper'

describe 'TokensController' do
  it "confirms users' accounts" do
    user = stub
    User.stub(:find_by_email!).with('john.doe@example.com') { user }
    UserAuthenticator.should_receive(:confirm_email!).with(user, 'A1b2C3')

    get '/tokens?email=john.doe@example.com&token_value=A1b2C3'

    last_response.should be_redirect
    last_response.location.should == 'http://example.org/sessions/new'
  end
end
