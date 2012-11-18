Planner.controllers :sessions do
  get :new do
    render current_path
  end

  post :create, :index do
    begin
      session = UserAuthenticator.login! params[:user].symbolize_keys
      cookies[:email] = session.user.email
      cookies[:session] = session.client_value

      redirect to('/')
    rescue UserAuthenticator::WrongPassword
      flash.now[:error] = "Wrong password entered!"
      halt 401
    rescue User::UserDoesNotExist
      flash.now[:error] = "That user doesn't exist!"
      halt 401
    end
  end

  delete :destroy, ':token' do
    agent = request.user_agent
    begin
      user = UserAuthenticator.authenticate_client! agent, cookies

      UserTokenRepository.destroy_session! user, params[:token]
      cookies.delete :token
      cookies.delete :email
    rescue UserAuthenticator::InvalidClient
      flash.now[:error] = "You aren't logged in anyways!"
      halt 401
    rescue UserTokenRepository::NoSuchSession
      flash.now[:error] = 'No such session belongs to you!'
      halt 404
    end
  end

  error 401 do
    render :haml, flash[:error]
  end
end
