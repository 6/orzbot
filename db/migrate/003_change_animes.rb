class ChangeAnimes < ActiveRecord::Migration
  def self.up
    rename_column :animes, :title_jp, :title_ja
  end
  
  def self.down
    rename_column :animes, :title_ja, :title_jp
  end
end
