module TimeHelper
  def self.seconds_to(time_jst)
    (self.to_jst(Time.now) - time_jst).round
  end
  
  def self.to_jst(time)
    time.in_time_zone('Asia/Tokyo')
  end
  
  def self.create_time_jst(year, month, day, hour, minute)
    # TODO ruby way to do this?
    Time.zone = "Asia/Tokyo"
    Chronic.time_class = Time.zone
    Chronic.parse("#{year}/#{month}/#{day} #{hour}:#{minute} +09:00")
  end
  
  def self.wday_diff(day1, day2, forwards)
    if forwards
      (0..6).to_a.rotate(day1).index(day2)
    else
      (0..6).to_a.rotate(day2).index(day1)
    end
  end
end
