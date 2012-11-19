require 'spec_helper'

describe "StudentsController" do
  context "get#new" do
    it "returns a sign up form" do
      get '/students/new'
      last_response.body.should include('Sign Up')
    end
  end

  context "post#create" do
    it "creates a new student account" do
      Student.should_receive(:create_account!).with(
        'name' => 'John Doe',
        'email' => 'john.doe@example.com',
        'password' => 'somepassword'
      )

      post '/students', :student => {
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      }, :confirm => 'somepassword'
    end

    it "does not create an account with mismatched passwords" do
      Student.should_not_receive(:create_account!)

      post '/students', :student => {
        :name => 'John Doe',
        :email => 'john.doe@example.com',
        :password => 'somepassword'
      }, :confirm => 'derp'

      last_response.status.should == 409
    end
  end
end
