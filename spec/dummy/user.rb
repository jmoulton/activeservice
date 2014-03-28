class User < ActiveService::Base
  self.base_uri = "http://localhost:3000/api/v1/users"

  attribute :name
  attribute :email

  has_many :microposts

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }  

  before_save { |user| user.email = user.email.downcase }  
end


# class User
#   include ActiveService::Model

#   self.base_uri = "http://localhost:3000/api/v1/users"

#   attribute :name, field: 'name'
#   attribute :email, field: 'email'
  
#   has_many :microposts

#   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#   validates :name,  presence: true, length: { maximum: 50 }
#   validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }  

#   before_save { |user| user.email = user.email.downcase }  
# end

# ActiveRecord equivalent

# class User < ActiveRecord::Base
  
#   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#   validates :name,  presence: true, length: { maximum: 50 }
#   validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }  

#   before_save { |user| user.email = user.email.downcase }    
# end