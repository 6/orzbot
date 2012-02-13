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
  
  def self.closest_date(start_date, days, ignore, forwards = true)
    # TODO clean this up
    now = self.to_jst(Time.now)
    closest = nil
    days.each{|d|
      diff = wday_diff(now.wday, d, forwards)
      ignore.each{|i|
        next if i.nil?
        date = forwards ? now + diff.days : now - diff.days
        diff += 7 if date.year == i.year and date.month == i.month and date.day == i.day
      }
      if diff == 0
        air_time = self.create_time_jst now.year, now.month, now.day, start_date.strftime("%H"), start_date.strftime("%M")
        diff = 7 if (forwards and now > air_time) or (not forwards and now < air_time)
      end
      closest = {:day => d, :diff => diff} if closest.nil? or diff < closest[:diff]
    }
    c = forwards ? now + closest[:diff].days : now - closest[:diff].days
    self.create_time_jst c.year, c.month, c.day, start_date.strftime("%H"), start_date.strftime("%M")
  end
end
