Planner.controller :sessions do
  get :new do
    render current_path
  end

  post :create, :index do
    session = UserAuthenticator.login! params[:user].symbolize_keys
    cookies[:email] = session.user.email
    cookies[:session] = session.client_value

    redirect to('/')
  end

  delete :destroy, ':token' do
    agent = request.user_agent
    user = UserAuthenticator.authenticate_client! agent, cookies

    UserTokenRepository.destroy_session! user, params[:token]
    cookies.delete :token
    cookies.delete :email
  end



  error UserAuthenticator::WrongPassword do
    flash.now[:error] = "Wrong password entered!"
    halt 401
  end

  error UserAuthenticator::InvalidClient do
    flash.now[:error] = "You aren't even logged in! Wat."
    halt 401
  end

  error User::UserDoesNotExist do
    flash.now[:error] = "That user doesn't exist!"
    halt 401
  end

  error UserTokenRepository::NoSuchSession do
    flash.now[:error] = "You aren't logged in with that session!"
    halt 403
  end



  error 401 do
    render :haml, flash[:error]
  end

  error 403 do
    render :haml, flash[:error]
  end
end
