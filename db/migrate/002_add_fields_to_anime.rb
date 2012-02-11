class AddFieldsToAnime < ActiveRecord::Migration
  def self.up
    change_table :animes do |t|
      t.string :air_days
    t.string :ignore_dates
    end
  end

  def self.down
    change_table :animes do |t|
      t.remove :air_days
    t.remove :ignore_dates
    end
  end
end
