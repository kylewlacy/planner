class UserTokenRepository
  class NoSuchSession < StandardError; end

  def self.generate_token_value(length = 8)
    value_length_error = 'value length must be greater than 2'
    raise ArgumentError, value_length_error unless length > 2

    rand(36**(length-1)...36**(length)).to_s(36)
  end

  def self.add_email_token(user)
    token = EmailToken.create!(:value => generate_token_value(16))
    user.email_tokens << token

    token
  end

  def self.add_session(user)
    session = Session.create!(
      :value        => generate_token_value(64),
      :client_value => generate_token_value(64)
    )
    user.sessions << session

    session
  end

  def self.destroy_session!(user, client_value)
    sessions = user.sessions.where(
      :client_value => 'A1b2C3'
    )

    raise NoSuchSession if sessions.empty?

    sessions.destroy_all!

    true
  end
end
