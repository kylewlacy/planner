class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.string :name

      t.references :user
      t.references :schedule_courses

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
