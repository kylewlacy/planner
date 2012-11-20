require './lib/user_schedule_repository'

describe UserScheduleRepository do
  it "adds schedules to users" do
    math = stub
    english = stub
    course_schedules = stub
    schedule = stub(:course_schedules => course_schedules)

    user = stub
    user.should_receive(:find_schedule).with(:default) { schedule }
    course_schedules.should_receive(:create!).with(
      :period => 1,
      :course => math,
      :start => WallClock.new(9, 00),
      :end => WallClock.new(10, 00)
    )
    course_schedules.should_receive(:create!).with(
      :period => 2,
      :course => english,
      :start => WallClock.new(10, 00),
      :end => WallClock.new(11, 00)
    )

    UserScheduleRepository.add_schedule!(
      user, :default,
      1 => {
        :course => math,
        :start => WallClock.new(9, 00),
        :end => WallClock.new(10, 00)
      }, 2 => {
        :course => english,
        :start => WallClock.new(10, 00),
        :end => WallClock.new(11, 00)
      }
    )
  end
end
