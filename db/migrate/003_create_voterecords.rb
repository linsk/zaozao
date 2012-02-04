class CreateVoterecords < ActiveRecord::Migration
  def self.up
    create_table :voterecords do |t|
			
	t.timestamps
    end
	add_column :voterecords , :cid , :integer
	add_column :voterecords , :type , :string ,:limit=>15
	add_column :voterecords , :uid , :integer
  end

  def self.down
    drop_table :voterecords
  end
end
