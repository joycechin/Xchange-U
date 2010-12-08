require 'spec_helper'

describe MatchingsController do

  describe "access control" do
  
    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @helped = Factory(:user, :email => Factory.next(:email))
    end

    it "should create a relationship" do
      lambda do
        post :create, :matching => { :followed_id => @helped }
        response.should be_redirect
      end.should change(Matching, :count).by(1)
    end
    
    it "should create a relationship using Ajax" do
      lambda do
        xhr :post, :create, :matching => { :helped_id => @helped }
        response.should be_success
        end.should change(Matching, :count).by(1)
      end
    end
    
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.help!(@helped)
      @matching = @user.relationships.find_by_followed_id(@helped)
    end

    it "should destroy a relationship" do
      lambda do
        delete :destroy, :id => @matching
        response.should be_redirect
      end.should change(Matching, :count).by(-1)
    end
    
    it "should destroy a relationship using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @matching
        response.should be_success
      end.should change(Matching, :count).by(-1)
    end
    
    
  end
end
