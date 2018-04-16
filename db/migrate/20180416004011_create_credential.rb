class CreateCredential < ActiveRecord::Migration[5.2]
  def up
  	create_table :credentials do |t|
  		t.string :username
      t.string :password
  	end
  end

  def down
  	drop_table :credentials
  end
end
