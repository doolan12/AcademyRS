class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :operating_system
  belongs_to :browser
end
