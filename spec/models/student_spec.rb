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
end
