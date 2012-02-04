class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
	
      t.timestamps
    end
	add_column :rankings , :cid , :integer
	add_column :rankings , :znum , :integer
  end

  def self.down
    drop_table :rankings
  end
end
