class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true

  validates :email, presence: true
  validates :email, uniqueness: { case_sensative: false }

  def login_hash
    token = JwtService.encode({user_id: self.id})
    self.attributes.slice('id', 'name').merge("token" => token)
  end

  class << self
  
    def authenticate(email: nil, password: nil)
      user = self.find_by(email: email)
      user if user && user.authenticate(password)
    end

  end
end