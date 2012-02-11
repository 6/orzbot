# Helper methods defined here can be accessed in any controller or view in the application

Orzbot.helpers do
  def format_date(datet)
    if datet.nil?
      "[none]"
    else
      datet.strftime("%Y/%m/%d %H:%M")
    end
  end
  
  def parse_anime_params(par)
    return nil unless par
    unless par['start_date'].nil?
      par['start_date'] = Chronic.parse(par[:start_date])
    end
    unless par['air_days'].nil?
      par['air_days'] = par['air_days'].join(',')
    end
    par
  end
  
  def get_locale(locale_s)
    if locale_s and %w[en ja].include?(locale_s)
      locale_s.to_sym
    else
      :en
    end
  end
end
