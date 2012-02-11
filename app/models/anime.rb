class Anime < ActiveRecord::Base
  validates_presence_of :title_en
  validates_presence_of :title_jp
end
