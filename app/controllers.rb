Orzbot.controllers  do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end
  
  get :home, :map => "/" do
    render :home
  end
  
  get :admin do
    if session[:is_admin]
      render 'admin/index'
    else
      render 'admin/login'
    end
  end
  
  post :admin_login do
    if params[:password] == ENV["ADMIN_PASS"]
      session[:is_admin] = true
    end
    redirect url_for(:admin)
  end
  
  get :admin_logout do
    session[:is_admin] = nil
    redirect url_for(:home)
  end
  
end
