class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # @user = User.new({
    # first_name: params[:user][:first_name],
    # last_name: params[:user][:last_name],
    # email: params[:user][:email]
    # })
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email)
  end
end
