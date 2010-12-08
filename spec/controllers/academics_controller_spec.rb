require 'spec_helper'

describe AcademicsController do
  render_views
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do
      before(:each) do
        @attr = { :learn => "math", :teach => "english" }
      end

      it "should not create a academic" do
        lambda do
         post :create, :academic => @attr
        end.should_not change(Academic, :count)
      end

      it "should render the home page" do
        post :create, :academic => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :learn => "Lorem ipsum", :teach => "Random" }
      end

      it "should create a academic post" do
        lambda do
          post :create, :academic => @attr
        end.should change(Academic, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :academic => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :academic => @attr
        flash[:success].should =~ /academic created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @academic = Factory(:academic, :user => @user)
      end
      
      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end
