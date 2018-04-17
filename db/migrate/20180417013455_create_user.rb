class CreateUser < ActiveRecord::Migration[5.2]
  def up
  	create_table :users do |t|
  		t.string :username
      t.string :password_digest
      t.string :f_name
      t.string :l_name
  	end
  end

  def down
  	drop_table :users
  end
end
