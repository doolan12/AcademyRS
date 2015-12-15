class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.string :status
      t.integer :assignee_id
      t.string :company
      t.string :course
      t.integer :operating_system_id
      t.integer :browser_id
      t.text :description

      t.timestamps null: false
    end
  end
end
