class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email.downcase! }
  validates :name, presence: true  , length: {maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true , length: {maximum: 255 } ,
                   format: {with:  VALID_EMAIL_REGEX } , 
                   uniqueness: { case_sensitive: false }
                   
  has_secure_password
  validates :password , presence: true , length: {minimum: 6 } , allow_nil: true
  
  class << self
    # Returns the hash digest of the given string.
      def digest(string)
        # what i understand is that we need a secure password that 
        # have a low cost (parameter that determines the computational cost to calculate the hash )
        # which means a minimun time 
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
      
       # Returns a random token.
      def new_token
        SecureRandom.urlsafe_base64
      end
  end
  
  def remember
    self.remember_token = User.new_token
    # the update attribute set the remember_token value to remember_digest 
    update_attribute(:remember_digest, User.digest(remember_token))
  end   
    
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget 
    update_attribute(:remember_digest , nil)
  end
end
