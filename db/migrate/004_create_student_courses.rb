class CreateStudentCourses < ActiveRecord::Migration
  def self.up
    create_table :student_courses do |t|
      t.text :json_data

      t.references :student
      t.references :course
    end
  end

  def self.down
    drop_table :student_courses
  end
end
