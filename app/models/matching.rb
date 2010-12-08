class Matching < ActiveRecord::Base
  attr_accessible :helped_id
  
  belongs_to :helper, :class_name => "User"
  belongs_to :helped, :class_name => "User"
  
  validates :helper_id, :presence => true
  validates :helped_id, :presence => true
  
end
