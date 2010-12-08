require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :academics, :dependent => :destroy
  
  # regular expression to ensure @college or @fas harvard emails
  email_regex = /\A[a-z\d\-.]+@(college|fas)\.harvard\.edu$/i
  
  # validation reqs for name, email, password fields
  validates :name, :presence => true,
				   :length => { :maximum => 50 }
  validates :email, :presence => true,
					:length => { :maximum => 100 },
					:format     => { :with => email_regex},
					:uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  
  before_save :encrypt_password

  def feed
      Academic.where("user_id = ?", id)
  end
  
  # checks if submitted pw == encrypted pw on file
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  # checks validation of email and password combo
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
	return nil if user.nil?
	return user if user.has_password?(submitted_password)
  end
  
  # authenticate the cookie's salt
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private # back-end methods only

  # method to encrypt password, using salt(unique to each user)
	def encrypt_password
      self.salt = make_salt if new_record?
	  self.encrypted_password = encrypt(password)
  end

	# method to encrypt strings
  def encrypt(string)
      secure_hash("#{salt}--#{string}") 
	end

	# salt: encryption of time of user creation+password
	def make_salt
	  secure_hash("#{Time.now.utc}--#{password}")
	end
	
	# secure hash function SHA2 from the digest lib
	def secure_hash(string)
	  Digest::SHA2.hexdigest(string)
	end
	
end
