class Course < ActiveRecord::Base
  belongs_to :user
  has_many :student_courses
  has_many :students, :through => :student_courses

  def data
    JSON.parse(self.json_data).symbolize_keys
  end

  def data=(new_data)
    self.json_data = new_data.to_json
  end
end
