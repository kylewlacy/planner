class UserAuthenticator
  class InvalidEmailToken < StandardError; end
  class WrongPassword < StandardError; end
  class InvalidClient < StandardError; end
  class UnconfirmedUser < StandardError; end

  def self.confirm_email!(user, token_value)
    token = user.email_tokens.where(:value => token_value).last
    raise InvalidEmailToken if token.nil?

    user.confirmed = true
    user.save

    token.destroy
  end

  def self.login!(credentials)
    user = User.find_by_email!(credentials[:email])

    raise UnconfirmedUser unless user.confirmed
    raise WrongPassword unless user.password == credentials[:password]

    UserTokenRepository.add_session(user)
  end

  def self.authenticate_client!(client_agent, client)
    user = User.find_by_email!(client[:email])
    client_value = unique_client_value(user, client_agent)

    unless BCrypt::Password.new(client[:token]) == client_value
      raise InvalidClient
    end

    user
  end

  def self.generate_client_string(user, client_agent)
    BCrypt::Password.create(
      unique_client_value(user, client_agent),
      :cost => ENCRYPTION_COST
    )
  end

  private
  def self.unique_client_value(user, client_agent)
    user.email + user.password.to_s + client_agent
  end
end
