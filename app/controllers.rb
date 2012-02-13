Orzbot.controllers  do
  before do
    Encoding.default_internal = nil
  end
  
  get :about do
    render :about
  end
  
  Orzbot.controllers :anime do
    before do
      redirect url(:home) unless session[:is_admin]
    end
    
    get :edit, :with => :id do
      @anime = Anime.find(params[:id])
      render 'anime/edit'
    end
    
    post :edit, :with => :id do
      @anime = Anime.find(params[:id])
      params['anime'] = parse_anime_params(params[:anime])
      if @anime.andand.update_attributes(params[:anime])
        redirect url(:home)
      else
        flash[:warning] = "Error!"
        redirect url(:anime, :edit, :id)
      end
    end
    
    post :create do
      params['anime'] = parse_anime_params(params[:anime])
      @anime = Anime.new(params[:anime])
      unless @anime.save
        flash[:warning] = "Error!"
      end
      redirect url(:home)
    end
  end
  
  Orzbot.controllers :admin do
    get :index do
      render 'admin/login'
    end

    post :login do
      session[:is_admin] = true if params[:password] == ENV["ADMIN_PASS"]
      redirect url(:home)
    end

    get :logout do
      session[:is_admin] = nil
      redirect url(:home)
    end
  end
  
  get :home, :map => "/(:locale)", :provides => [:html, :rss] do
    I18n.locale = get_locale(params[:locale])
    @animes = Anime.all(:order => get_locale(params[:locale]) == :ja ? 'lower(title_ja) ASC' : 'lower(title_en) ASC')
    render :home
  end
end
