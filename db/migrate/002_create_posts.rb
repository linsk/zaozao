class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|

      t.timestamps
    end
	add_column :posts , :title , :text 
	add_column :posts , :link , :string 
	add_column :posts , :tag , :string 
	add_column :posts , :text , :text 
	add_column :posts , :uid , :integer
	add_column :posts , :vote , :integer
	add_column :posts , :znum , :integer
	add_column :posts , :active , :boolean ,:default =>1
  end

  def self.down
    drop_table :posts
  end
end
