# You can set the default delivery settings from your app through:
#
#   set :delivery_method, :smtp => {
#     :address         => 'smtp.yourserver.com',
#     :port            => '25',
#     :user_name       => 'user',
#     :password        => 'pass',
#     :authentication  => :plain, # :plain, :login, :cram_md5, no auth by default
#     :domain          => "localhost.localdomain" # the HELO domain provided by the client to the server
#   }
#
# or sendmail (default):
#
#   set :delivery_method, :sendmail
#
# or for tests:
#
#   set :delivery_method, :test
#
# and then all delivered mail will use these settings unless otherwise specified.
#

Planner.mailer :user do
  # Message definitions here...
  email :confirm_account do |user, token|
    url = Planner.url_for(
      :tokens,
      :show,
      :email => user.email,
      :token_value => token.value
    )

    to user.email
    subject "Account Confirmation"
    locals :user => user, :url => url
    render 'user/confirm_account'
  end
end
