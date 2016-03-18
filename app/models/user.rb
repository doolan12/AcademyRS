class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :recoverable
  has_many :tickets

  validates_presence_of :email , :password

  attr_accessor :role

  after_create :create_role
  after_update :create_role

  def create_role
    self.roles.destroy_all
    if self.role == "manager"  and !self.has_role? :manager
      self.add_role  :manager
    elsif self.role == "customer"  and !self.has_role? :customer
      self.add_role  :customer
    elsif self.role == "support_staff" and !self.has_role? :support_staff
      self.add_role  :support_staff
    elsif !self.has_role? :customer
      self.add_role  :customer
    end
  end

end
