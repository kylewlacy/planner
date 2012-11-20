class CourseSchedule < ActiveRecord::Base
  belongs_to :course
  belongs_to :schedule

  def start
    WallClock.new(self.start_integer)
  end

  def start=(new_start)
    self.start_integer = new_start.to_i
  end

  def end
    WallClock.new(self.end_integer)
  end

  def end=(new_end)
    self.end_integer = new_end.to_i
  end
end
