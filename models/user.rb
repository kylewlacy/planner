class User < ActiveRecord::Base
  class EmailAlreadyUsed < StandardError; end

  attr_accessible :first_name, :last_name, :email, :password
  validates_uniqueness_of :email
  has_many :tokens

  def self.create_account(first, last, email, password)
    begin
      user = create!(
        :first_name => first,
        :last_name => last,
        :email => email,
        :password => password
      )
    rescue ActiveRecord::RecordInvalid => exception
      raise EmailAlreadyUsed if User.exists_with_email?(email)
      raise exception
    end
    UserTokenRepository.add_email_token(user)

    user
  end

  def self.exists_with_email?(email)
    not User.find_by_email(email).empty?
  end

  def self.find_by_email(email)
    User.where(:email => email).first
  end
end