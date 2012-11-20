require 'spec_helper'

describe StudentCourse do
  it "can be attached to an existing course" do
    course = Course.create!(:data => {:room => '101', :building => '203'})
    student_course = StudentCourse.create!(
      :course => course,
      :data => {:room => '102'}
    )

    student_course.data.should == {
      :room => '102', :building => '203'
    }
  end
end
