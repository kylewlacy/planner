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
  end
end
