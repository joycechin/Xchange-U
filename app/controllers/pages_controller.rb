class PagesController < ApplicationController

  def home
    @title = "Home"
    if signed_in?
      @academic = Academic.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def faq
    @title = "FAQ"
  end
  
end
