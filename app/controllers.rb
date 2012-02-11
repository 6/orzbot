Orzbot.controllers  do
  before do
    Encoding.default_internal = nil
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
      render 'anime/edit'
    end
    
    post :edit, :with => :id do
      @anime = Anime.find(params[:id])
      params['anime'] = parse_anime_params(params[:anime])
      if @anime.andand.update_attributes(params[:anime])
        flash[:notice] = "Updated!"
        redirect url(:home)
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
      redirect url(:home)
    end
  end
  
  Orzbot.controllers :admin do
    before :except => [:index, :login] do
      unless session[:is_admin]
        redirect url(:home)
      end
    end

    get :index do
      render 'admin/login'
    end

    post :login do
      if params[:password] == ENV["ADMIN_PASS"]
        session[:is_admin] = true
      end
      redirect url(:home)
    end

    get :logout do
      session[:is_admin] = nil
      redirect url(:home)
    end
  end
  
  get :home, :map => "/(:locale)", :provides => [:html, :rss] do
    I18n.locale = get_locale(params[:locale])
    @animes = Anime.all(:order => 'updated_at ASC')
    render :home
  end
end
