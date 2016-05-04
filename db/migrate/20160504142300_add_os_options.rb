class AddOsOptions < ActiveRecord::Migration
  def change
  	OperatingSystem.create(:name => "Linux")
  	OperatingSystem.create(:name => "Mac")
  	OperatingSystem.create(:name => "Windows")
  end
end
