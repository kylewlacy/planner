require 'spec_helper'

describe Schedule do
  it "contains courses for users" do
    student = Student.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'paswrod'
    )
    course = student.create_course!(:name => 'Math')

    UserScheduleRepository.add_schedule!(
      student, :default,
      1 => {
        :course => course,
        :start => WallClock.new(11, 30, :am),
        :end => WallClock.new(12, 30, :pm)
      }
    )
    schedule = student.find_schedule(:default)

    schedule.should be_a(Schedule)
    schedule.course_schedules.count.should == 1
    schedule.courses.should == [course]
  end
end
