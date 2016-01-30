class ChangeBrowserDataType < ActiveRecord::Migration
  def change
    change_column :tickets , :browser_id , :string
  end
end
