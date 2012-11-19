class Token < ActiveRecord::Base
  validates_presence_of :value
  belongs_to :user
end
