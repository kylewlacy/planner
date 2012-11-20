require 'spec_helper'

describe CourseSchedule do
  it "connects courses to schedules with a time" do
    course = Course.create!
    schedule = Schedule.create!

    course_schedule = CourseSchedule.create!(
      :course => course,
      :schedule => schedule,
      :start => WallClock.new(9, 00),
      :end => WallClock.new(10, 00)
    )

    course_schedule.start
    course_schedule.course.should == course
    course_schedule.schedule.should == schedule
    course_schedule.start.should == WallClock.new(9, 00)
    course_schedule.end.should == WallClock.new(10, 00)
  end
end
