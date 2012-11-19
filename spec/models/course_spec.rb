require 'spec_helper'

describe Course do
  it "belongs to a user" do
    teacher = Teacher.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'asdf'
    )
    course = Course.create!(
      :name => 'Math',
      :user => teacher,

      :data => {
        :room => '101'
      }
    )

    course.user.should == teacher
  end

  it "has students" do
    teacher = Teacher.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'asdf'
    )

    course = Course.create!(
      :name => 'Math',
      :user => teacher,

      :data => {
        :room => '101'
      }
    )

    ['Bob Doe', 'Jim Doe', 'Jack Doe'].each do |name|
      student = Student.create_account!(
        :name => name,
        :email => "#{name.split(' ').first.downcase}@example.com",
        :password => 'jkl'
      )
      course.students << student
    end

    course.students.count.should == 3
  end

  it "has miscellaneous data" do
    course = Course.create!(
      :name => 'Math',
      :data => {
        :room => '101',
        :building => '203'
      }
    )

    course.data.should == {
      :room => '101',
      :building => '203'
    }
  end
end
