class User < ActiveRecord::Base
  class EmailAlreadyUsed < StandardError; end

  attr_accessible :name, :email, :password
  validates_uniqueness_of :email
  has_many :tokens

  def self.create_account(attributes)
    begin
      user = create!(attributes)
    rescue ActiveRecord::RecordInvalid => exception
      raise EmailAlreadyUsed if User.exists_with_email?(attributes[:email])
      raise exception
    end
    UserTokenRepository.add_email_token(user)

    user
  end

  def self.exists_with_email?(email)
    not User.find_by_email(email).nil?
  end

  def name
    [first_name, last_name].join(' ')
  end

  def name=(new_name)
    self.first_name, self.last_name = new_name.split(' ', 2)
  end

  def password
    BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    self.password_hash = BCrypt::Password.create(
      new_password, :cost => ENCRYPTION_COST
    ).to_s
  end
end
