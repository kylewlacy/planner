class CreateCourseSchedules < ActiveRecord::Migration
  def self.up
    create_table :course_schedules do |t|
      t.references :course
      t.references :schedule
      t.integer :period
      t.integer :start_integer
      t.integer :end_integer

      t.timestamps
    end
  end

  def self.down
    drop_table :course_schedules
  end
end
