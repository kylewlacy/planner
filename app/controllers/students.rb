Planner.controller :students do
  get :new do
    render current_path
  end

  post :create, :index do
    unless params[:confirm] == params[:student][:password]
      flash.now[:error] = "Passwords do not match"
      halt 409
    end
    Student.create_account! params[:student]
    redirect to(url_for :sessions, :new)
  end
end
