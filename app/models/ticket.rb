class Ticket < ActiveRecord::Base
  resourcify

  belongs_to :user
  belongs_to :operating_system
  belongs_to :web_browser
  belongs_to :assignee , :class_name => "User"

  validates_presence_of :company , :description , :course

  before_create :set_status

  attr_accessor :from_date , :to_date

  def set_status
    self.status = "Unresolved"
  end
end
