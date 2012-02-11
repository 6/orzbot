# Helper methods defined here can be accessed in any controller or view in the application

Orzbot.helpers do
  def format_date(datet, only_date = false)
    if datet.nil?
      "[none]"
    else
      only_date ? datet.strftime("%Y/%m/%d") : datet.strftime("%Y/%m/%d %H:%M")
    end
  end
  
  def parse_anime_params(par)
    return nil unless par
    unless par['start_date'].nil?
      Time.zone = "Asia/Tokyo"
      Chronic.time_class = Time.zone
      par['start_date'] = Chronic.parse(par[:start_date])
    end
    unless par['air_days'].nil?
      par['air_days'] = par['air_days'].join(',')
    end
    par
  end
  
  def get_locale(locale_s)
    locale_s = locale_s[0] if locale_s.is_a? Array
    if locale_s and %w[en ja].include?(locale_s)
      locale_s.to_sym
    else
      :en
    end
  end
end
