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
  
  def locale_string
    # English should be blank string so don't have duplicate content
    I18n.locale == :en ? nil : I18n.locale
  end
  
  # based on:
  # http://stackoverflow.com/questions/1065320/in-rails-display-time-between-two-dates-in-english
  def time_diff(from_time, to_time)
    distance_in_seconds = distance_in_seconds_copy = ((to_time - from_time).abs).round
    components = []
    # TODO internationalize
    %w(day hour minute second).each do |interval|
      next if interval == 'second' and distance_in_seconds >= 60 * 60
      next if interval == 'minute' and distance_in_seconds >= 60 * 60 * 24
      next if interval == 'hour' and distance_in_seconds >= 60 * 60 * 24 * 7
      if distance_in_seconds_copy >= 1.send(interval)
        delta = (distance_in_seconds_copy / 1.send(interval)).floor
        distance_in_seconds_copy -= delta.send(interval)
        components << pluralize(delta, interval)
      end
    end
    components.join(", ")
  end
end
