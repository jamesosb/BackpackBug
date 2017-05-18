class Plan < ActiveRecord::Base
  validates :name, presence: true
  attr_accessible :complete, :desc, :name, :position, :plantype

  acts_as_list
end
