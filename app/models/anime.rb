class Anime < ActiveRecord::Base
  WDAY_HASH = {"Mo"=>1,"Tu"=>2,"We"=>3,"Th"=>4,"Fr"=>5,"Sa"=>6,"Su"=>0}

  validates_presence_of :title_en
  validates_presence_of :title_ja
  
  after_create :set_defaults
  
  def self.airing
    animes = []
    all().each{|a|
      next unless a.airing?
      animes << {:model => a, :status => a.status}
    }
    animes.sort!{|x,y|
      x[:status][:next_date] <=> y[:status][:next_date]
    }
    animes
  end
  
  def start_date
    start = read_attribute(:start_date)
    start ? TimeHelper.to_jst(start) : nil
  end

  def status
    # TODO clean this up
    ignore = self.parsed_ignore_dates
    days = self.numeric_air_days
    start = self.start_date
    days.rotate! days.index(start.wday) # start with correct weekday
    days.sort!
    episodes_per_week = days.length
    i = 0
    episode_count = 0
    wk = 0
    while 1
      date = start + wk.weeks + TimeHelper.wday_diff(start.wday, days[0], true).days
      break if date > Time.now
      days.rotate!
      ignore_this_episode = false
      ignore.each{|i|
        ignore_this_episode = true if i.year == date.year and i.month == date.month and i.day == date.day
      }
      episode_count += 1 unless ignore_this_episode
      i += 1
      wk += 1 if i % episodes_per_week == 0
    end
    {
      :prev_date => TimeHelper.closest_date(start, days, ignore, false),
      :next_date => TimeHelper.closest_date(start, days, ignore),
      :prev_episode_number => episode_count
    }
  end
  
  def airing?
    self.started_airing? and not self.finished_airing?
  end
  
  def started_airing?
    self.start_date - Time.now > 0 ? false : true
  end
  
  def finished_airing?
    return false if self.episode_count.nil?
    self.status[:prev_episode_number] >= self.episode_count
  end
  
  def on_air_now?
    dur = self.duration_minutes
    return false if dur.nil?
    start = self.start_date
    now = Time.now
    days = self.numeric_air_days
    ignore = self.parsed_ignore_dates
    [TimeHelper.closest_date(start, days, ignore, false), TimeHelper.closest_date(start, days, ignore)].each{|d|
      end_date = d + (dur * 60)
      return end_date if now > d and now < end_date
    }
    false
  end
  
  def numeric_air_days
    self.air_days.split(",").map{|wday_s| WDAY_HASH[wday_s]}.sort
  end
  
  def parsed_ignore_dates
    ignore = self.ignore_dates.split(",").map{|i| Chronic.parse(i)}.sort
    ignore[0].nil? ? [] : ignore
  end
  
  def set_defaults
    self.air_days ||= WDAY_HASH.invert[self.start_date.wday]
    self.duration_minutes ||= 30
    self.save
  end
end
