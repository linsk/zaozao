class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|

      t.timestamps
    end
	add_column :accounts , :username , :string ,:limit =>100,:unique=>true
	add_column :accounts , :password , :string ,:limit =>100
	add_column :accounts , :email , :string ,:limit =>100
	add_column :accounts , :active , :boolean ,:default =>1
	add_column :accounts , :posts , :integer ,:default =>0
	add_column :accounts , :admin , :integer ,:default =>0

	
  end

  def self.down
    drop_table :accounts
  end
end
