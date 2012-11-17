class UserTokenRepository
  def self.generate_token_value(length = 8)
    value_length_error = 'value length must be greater than 2'
    raise ArgumentError, value_length_error unless length > 2

    rand(36**(length-1)...36**(length)).to_s(36)
  end

  def self.add_email_token(user)
    token = EmailToken.create!(:value => generate_token_value(16))
    user.tokens << token

    token
  end

  def self.add_session(user)
    session = Session.create!(
      :value        => generate_token_value(64),
      :client_value => generate_token_value(64)
    )
    user.tokens << session

    session
  end
end
