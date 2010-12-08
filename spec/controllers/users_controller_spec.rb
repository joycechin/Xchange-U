require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      second = Factory(:user, :email => "another@college.harvard.edu")
      third  = Factory(:user, :email => "another@college.harvard.edu")

      @users = [@user, second, third]
    end

    it "should be successful" do
        get :index
        response.should be_success
      end

    it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

    it "should have an element for each user" do
      get :index
        @users.each do |user|
        response.should have_selector("li", :content => user.name)
        end
    end
    
  end
  
  end
  
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
    
    it "should show the user's academic recording" do
      mp1 = Factory(:academic, :user => @user, :learn => "Foo bar", :teach => "Bar foo")
      mp2 = Factory(:academic, :user => @user, :learn => "Baz quux", :teach => "Quux baz")
      get :show, :id => @user
      response.should have_selector("span.learn", :learn => mp1.content)
      response.should have_selector("span.teach", :teach => mp1.content)
      response.should have_selector("span.learn", :learn => mp2.content)
      response.should have_selector("span.teach", :teach => mp2.content)
    end
    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[email='user[email]'][type='text']")
    end
        
    it "should have a password field" do
      get :new
      response.should have_selector("input[password='user[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[password_confirmation='user[password_confirmation]'][type='password']")
    end
  end
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

        before(:each) do
          @attr = { :email => "", :name => "", :password => "",
                    :password_confirmation => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector("title", :content => "Edit user")
        end
      end

    describe "success" do

        before(:each) do
          @attr = { :name => "New Name", :email => "user@college.harvard.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
        end

        it "should change the user's attributes" do
          put :update, :id => @user, :user => @attr
          @user.reload
          @user.name.should  == @attr[:name]
          @user.email.should == @attr[:email]
        end

        it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
        end

        it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
        end
      end
  end
  
  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
            :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  
    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
          
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end

  describe "follow pages" do

    describe "when not signed in" do

      it "should protect 'helping'" do
        get :helping, :id => 1
        response.should redirect_to(signin_path)
      end

      it "should protect 'helpers'" do
        get :helpers, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "when signed in" do

       before(:each) do
         @user = test_sign_in(Factory(:user))
         @other_user = Factory(:user, :email => Factory.next(:email))
         @user.help!(@other_user)
       end

       it "should show user following" do
         get :helping, :id => @user
         response.should have_selector("a", :href => user_path(@other_user),
                                            :content => @other_user.name)
       end

       it "should show user followers" do
         get :helpers, :id => @other_user
         response.should have_selector("a", :href => user_path(@user),
                                            :content => @user.name)
       end
     end
  end
end
