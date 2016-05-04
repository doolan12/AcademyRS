class MakeAllTypesAsGeneral < ActiveRecord::Migration
  def change
  	Ticket.where(:ticket_type => nil).update_all(:ticket_type => "General")
  end
end
