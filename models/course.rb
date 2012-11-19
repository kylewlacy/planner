class Course < ActiveRecord::Base
  belongs_to :user
  has_many :student_courses
  has_many :students, :through => :student_courses
end
