module TimeHelper
  def self.seconds_to(time_jst)
    (self.to_jst(Time.now) - time_jst).round
  end
  
  def self.to_jst(time)
    time.in_time_zone('Asia/Tokyo')
  end
end
