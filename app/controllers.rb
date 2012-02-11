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
  
  before do
    Encoding.default_internal = nil
  end
  
  get :home, :map => "/(:locale)", :provides => [:html, :rss] do
    I18n.locale = get_locale(params[:locale])
    @animes = Anime.all(:order => 'updated_at ASC')
    render :home
  end
  
  get :about do
    render :about
  end
  
  Orzbot.controllers :anime do
    before do
      unless session[:is_admin]
        redirect url(:home)
      end
    end
    
    get :edit, :with => :id do
      @anime = Anime.find(params[:id])
      render 'admin/anime_edit'
    end
    
    post :edit, :with => :id do
      @anime = Anime.find(params[:id])
      params['anime'] = parse_anime_params(params[:anime])
      if @anime.andand.update_attributes(params[:anime])
        flash[:notice] = "Updated!"
        redirect url(:admin, :index)
      else
        flash[:notice] = "Error!"
        redirect url(:anime, :edit, :id)
      end
    end
    
    post :create do
      params['anime'] = parse_anime_params(params[:anime])
      @anime = Anime.new(params[:anime])
      if @anime.save
        flash[:notice] = "Success!"
      else
        flash[:warning] = "Error!"
      end
      redirect url(:admin, :index)
    end
  end
  
  Orzbot.controllers :admin do
    before :except => [:index, :login] do
      unless session[:is_admin]
        redirect url(:admin, :index)
      end
    end

    get :index do
      if session[:is_admin]
        @animes = Anime.all(:order => 'updated_at ASC')
        render 'admin/index'
      else
        redirect url(:admin, :login)
      end
    end

    get :login do
      render 'admin/login'
    end

    post :login do
      if params[:password] == ENV["ADMIN_PASS"]
        session[:is_admin] = true
      end
      redirect url(:admin, :index)
    end

    get :logout do
      session[:is_admin] = nil
      redirect url(:home)
    end
  end
end
