class AcademicsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def create
    @academic  = current_user.academics.build(params[:academic])
    if @academic.save
      flash[:success] = "AcademicX Submitted!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @academic.destroy
    redirect_back_or root_path
  end
  
  private
  
    def authorized_user
      @academic = Academic.find(params[:id])
      redirect_to root_path unless current_user?(@academic.user)
    end

end
