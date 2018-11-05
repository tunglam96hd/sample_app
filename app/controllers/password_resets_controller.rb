class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".can_not")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".pass_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    redirect_to root_url
    flash[:danger] = t ".notfound"
  end

  def valid_user
    return if @user&.activated? && @user.authenticated? :reset, params[:id]
    flash[:danger] = t ".invalid"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".pass_reset_expired"
    redirect_to new_password_reset_url
  end
end
