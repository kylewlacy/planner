class User < ActiveRecord::Base
  class EmailAlreadyUsed < StandardError; end
  class UserDoesNotExist < StandardError; end

  attr_accessible :name, :email, :password
  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name, :email, :password_hash

  has_many :tokens
  has_many :sessions
  has_many :email_tokens

  has_many :courses
  has_many :schedules

  def self.create_account!(attributes)
    begin
      user = create!(attributes)
    rescue ActiveRecord::RecordInvalid => exception
      raise EmailAlreadyUsed if User.exists_with_email?(attributes[:email])
      raise exception
    end
    UserTokenRepository.add_email_token(user)

    user
  end

  def self.find_by_email!(email)
    raise User::UserDoesNotExist unless User.exists_with_email?(email)
    User.find_by_email(email)
  end

  def self.exists_with_email?(email)
    not User.find_by_email(email).nil?
  end

  def name
    [self.first_name, self.last_name].join(' ')
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

  def add_course!(attributes)
    self.courses.create!(attributes)
  end

  def find_schedule(name)
    self.schedules.where(:name => name).last
  end

  def find_schedule!(name)
    schedule = self.find_schedule(name)
    if schedule.nil?
      schedule = self.schedules.create!(
        :name => name
      )
    end

    schedule
  end
end
