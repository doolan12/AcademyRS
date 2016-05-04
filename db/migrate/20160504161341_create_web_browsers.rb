class CreateWebBrowsers < ActiveRecord::Migration
  def change
    create_table :web_browsers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
