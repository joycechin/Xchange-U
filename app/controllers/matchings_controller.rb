class MatchingsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:matching][:helped_id])
    current_user.help!(@user)
    # take approprieate action depending on the kind of request
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Matching.find(params[:id]).helped
    current_user.unhelp!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
