require 'spec_helper'

describe Teacher do
  it "can be created" do
    teacher = Teacher.create_account!(
      :name => 'John Doe',
      :email => 'john.doe@example.com',
      :password => 'imateacher'
    )

    teacher.type.should == 'Teacher'
  end
end
