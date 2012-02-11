class CreateAnimes < ActiveRecord::Migration
  def self.up
    create_table :animes do |t|
      t.string :title_en
      t.string :title_jp
      t.integer :episode_count
      t.integer :duration_minutes
      t.datetime :start_date
      t.integer :mal_id
      t.timestamps
    end
  end

  def self.down
    drop_table :animes
  end
end
