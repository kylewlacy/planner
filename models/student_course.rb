class StudentCourse < ActiveRecord::Base
  belongs_to :student
  belongs_to :course

  def data
    data = JSON.parse(self.json_data).symbolize_keys
    unless self.course.nil?
      self.course.data.merge(data)
    end
  end

  def data=(new_data)
    self.json_data = new_data.to_json
  end
end
