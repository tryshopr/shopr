class Shoppe::User < ActiveRecord::Base
  has_secure_password
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email_address, :presence => true
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def short_name
    "#{first_name} #{last_name[0,1]}"
  end
  
  def self.authenticate(email_address, password)
    user = self.where(:email_address => email_address).first
    return false if user.nil?
    return false unless user.authenticate(password)
    user
  end
  
end
