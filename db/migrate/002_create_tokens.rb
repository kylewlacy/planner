class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.integer :user_id
      t.string :value
      t.string :client_value
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :tokens
  end
end
