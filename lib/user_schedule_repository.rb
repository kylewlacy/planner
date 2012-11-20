class UserScheduleRepository
  def self.add_schedule!(user, name, schedules)
    schedule = user.find_schedule(name)
    schedules.each do |period, course_schedule|
      schedule.course_schedules.create!(
        :period => period,
        :course => course_schedule[:course],
        :start => course_schedule[:start],
        :end => course_schedule[:end]
      )
    end

    schedule
  end
end
