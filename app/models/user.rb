class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :recoverable
  has_many :tickets

  validates_presence_of :email , :name , :password

  attr_accessor :role

  after_create :create_role

  def create_role
    if self.role == "manager"
      self.add_role  :manager
    elsif self.role == "customer"
      self.add_role  :customer
    elsif self.role == "support_staff"
      self.add_role  :support_staff
    else
      self.add_role  :customer
    end
  end

end
