class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :recoverable
  has_many :tickets
  before_create :set_encrypted_password

  def set_encrypted_password
    puts "trying to set password-------#{self.password}   ****    --->"
    self.encrypted_password = User.new(:password => self.password).encrypted_password
  end

end
