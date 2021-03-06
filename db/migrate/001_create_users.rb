class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_hash
      t.boolean :confirmed, :default => false

      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
