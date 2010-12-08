class Academic < ActiveRecord::Base
  attr_accessible :learn, :teach, :description
  
  belongs_to :user
  
  validates :learn, :presence => true
  validates :teach, :presence => true
  validates :description, :presence => true
  validates :user_id, :presence => true
  
  default_scope :order => 'academics.created_at DESC'
  
  # Return microposts from the users being followed by the given user.
  scope :from_users_helped_by, lambda { |user| helped_by(user) }
  
  #implementing a funtion that identifies the helped
  def self.from_users_helped_by(user)
    helped_ids = user.helping.map(&:id).join(", ")
    where("user_id IN (#{helped_ids}) OR user_id = ?", user)
  end
  
  SUBJECTS = [
    ["Math", "math"],
    ["English", "english"]
    ].freeze
  
  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.helped_by(user)
      helped_ids = user.helping.map(&:id).join(", ")
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
          { :user_id => user })
    end
  
end