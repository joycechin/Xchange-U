class Academic < ActiveRecord::Base
  attr_accessible :learn, :teach, :description
  
  belongs_to :user
  
  validates :learn, :presence => true
  validates :teach, :presence => true
  validates :description, :presence => true
  validates :user_id, :presence => true
  
  default_scope :order => 'academics.created_at DESC'
  
  SUBJECTS = [
    ["Math", "math"],
    ["English", "english"]
    ].freeze
  
  
end