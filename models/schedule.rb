class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :course_schedules
  has_many :courses, :through => :course_schedules
end
