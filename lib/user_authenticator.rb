class UserAuthenticator
  class InvalidEmailToken < StandardError; end
  class WrongPassword < StandardError; end
  class InvalidClient < StandardError; end

  def self.confirm_email!(user, token_value)
    token = user.tokens.where(
      :value => token_value,
      :type => 'EmailToken'
    ).last
    raise InvalidEmailToken if token.nil?

    token.destroy
  end

  def self.login!(credentials)
    user = User.find_by_email(credentials[:email])

    unless user.password == credentials[:password]
      raise WrongPassword
    end

    UserTokenRepository.add_auth_token(user)
  end

  def self.authenticate_client!(client_agent, client)
    user = User.find_by_email(client[:email])
    client_value = unique_client_value(user, client_agent)

    unless BCrypt::Password.new(client[:client_string]) == client_value
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
