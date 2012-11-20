class Student < User
  has_many :student_courses

  def enrolled_courses
    student_courses = self.student_courses.map do |student_course|
      student_course.course
    end

    (self.courses + student_courses).uniq
  end
end
