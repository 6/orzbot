Orzbot.controllers  do
  before do
    Encoding.default_internal = nil
    I18n.locale = get_locale(params[:locale] || params[:hl]) || :en
  end
  
  get :about do
    render :about
  end
  
  get '/index.php' do
    redirect url(:home, :locale => locale_string), 301
  end
  
  Orzbot.controllers :anime do
    before :except => :index do
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
        redirect url(@anime.started_airing? ? :home : :upcoming)
      else
        flash[:warning] = "Error!"
        redirect url(:anime, :edit, :id)
      end
    end
    
    post :create do
      params['anime'] = parse_anime_params(params[:anime])
      @anime = Anime.new(params[:anime])
      if @anime.save
        redirect url(@anime.started_airing? ? :home : :upcoming)
      else
        flash[:warning] = "Error!"
        redirect url(:home)
      end
    end
    
    get :index, :map => "/anime/:id(/:locale)" do
      @anime = Anime.find(params[:id])
      render 'anime/index'
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
  
  get :upcoming, :map => "/upcoming(/:locale)", :provides => [:html, :rss] do
    @animes = []
    Anime.where("start_date > ?", Time.now).order("start_date ASC").each{|a|
      @animes << {:model => a, :status => nil, :on_air_now => false}
    }
    @action = :upcoming
    render :home
  end
  
  get :home, :map => "/(:locale)", :provides => [:html, :rss] do
    @animes = Anime.airing
    @action = :home
    render :home
  end
end
