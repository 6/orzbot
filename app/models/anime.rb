class Anime < ActiveRecord::Base
  validates_presence_of :title_en
  validates_presence_of :title_ja
  
  def start_date
    start = read_attribute(:start_date)
    start ? TimeHelper.to_jst(start) : nil
  end
  
  def started_airing?
    self.start_date - Time.now > 0 ? false : true
  end
  
  def numeric_air_days
    self.air_days.split(",").map{|wday_s|
      {"Mo"=>1,"Tu"=>2,"We"=>3,"Th"=>4,"Fr"=>5,"Sa"=>6,"Su"=>0}[wday_s]
    }.sort
  end
  
  def parsed_ignore_dates
    self.ignore_dates.split(",").map{|i| Chronic.parse(i)}.sort
  end
end
