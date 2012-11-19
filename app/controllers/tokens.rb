Planner.controller :tokens do
  get :show, :index do
    user = User.find_by_email! params[:email]
    UserAuthenticator.confirm_email! user, params[:token_value]

    redirect to(url_for :sessions, :new)
  end
end
