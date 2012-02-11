class Anime < ActiveRecord::Base
  validates_presence_of :title_en
  validates_presence_of :title_ja
  
  def start_date
    start = read_attribute(:start_date)
    start ? TimeHelper.to_jst(start) : nil
  end
end
