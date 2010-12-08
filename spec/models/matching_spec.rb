require 'spec_helper'

describe Matching do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    
    @matching = @follower.matchings.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @matching.save!
  end
  
  describe "follow methods" do

    before(:each) do
      @matching.save
    end

    it "should have a helper attribute" do
      @matching.should respond_to(:helper)
    end

    it "should have the right helper" do
      @matching.follower.should == @helper
    end

    it "should have a helped attribute" do
      @matching.should respond_to(:helped)
    end

    it "should have the righthelped user" do
      @matching.followed.should == @helped
    end
  end
  
end
