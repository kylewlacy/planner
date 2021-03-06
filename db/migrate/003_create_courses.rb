class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.text :json_data

      t.references :user
      t.references :student_courses

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
