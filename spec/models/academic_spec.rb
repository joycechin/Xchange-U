require 'spec_helper'

describe Academic do
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :learn => "value for learn",
      :teach => "value for teach"
    }
  end
  
  it "should create a new instance given valid attributes" do
    @user.academics.create!(@attr)
  end
  
  describe "user associations" do
    it "should have a user attribute" do
      @academic.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @academic.user_id.should == @user.id
      @academic.user.should == @user
    end
  end
  
  describe "validations" do

    it "should require a user id" do
      Academic.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.academics.build(:learn => "  " || :teach => "  ").should_not be_valid
    end
    
  end
  
  describe "from_users_helped_by" do

    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))

      @user_post  = @user.academics.create!(:learn => "foo", :teach => "foo", 
                                            :content => "foo")
      @other_post = @other_user.academics.create!(:learn => "foo", :teach => "foo", 
                                                  :content => "foo")
      @third_post = @third_user.academics.create!(:learn => "foo", :teach => "foo", 
                                                  :content => "foo")

      @user.help!(@other_user)
    end

      it "should have a from_users_helped_by class method" do
        Academic.should respond_to(:from_users_helped_by)
      end

      it "should include the helped user's microposts" do
        Academic.from_users_helped_by(@user).should include(@other_post)
      end

      it "should include the user's own academics" do
        Academic.from_users_helped_by(@user).should include(@user_post)
      end

      it "should not include an unhelped user's microposts" do
        Academic.from_users_helped_by(@user).should_not include(@third_post)
      end
    end
  
end
