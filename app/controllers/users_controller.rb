class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :edit ]

  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
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
      redirect_to new_user_path, alert: @user.errors.full_message
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      redirect_to user_path(@user), notice: "Usuario actualizado"
    else
      redirect_to edit_user_path(@user), alert: @user.errors.full_message
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params
      .require(:user)
      .permit(:first_name, :last_name, :email)
  end

  def set_trainer # terminar
  end
end
