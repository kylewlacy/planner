require 'spec_helper'

describe Student do
  it "can be created" do
    student = Student.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'imastudent'
    )

    student.type.should == 'Student'
  end

  it "lists all the courses enrolled" do
    student = Student.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'stillastudent'
    )

    teacher = Teacher.create_account!(
      :name => 'Michael Doe',
      :email => 'michael.doe@example.com',
      :password => 'imateacher'
    )

    math = student.create_course!(:name => 'Math')
    english = teacher.create_course!(:name => 'English')
    english.students << student

    student.enrolled_courses.should == [math, english]
  end
end
