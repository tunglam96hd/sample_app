class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :load_user, except: %i(index create new)

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def index
    @users = User.by_attributes.order(:id).page params[:page]
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".profile_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_url
    else
      flash[:danger] = t ".failed"
      redirect_to root_path
    end
  end
  
  private

    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end

    def logged_in_user
      return if logged_in?
      store_location
      flash[:danger] = t ".please_login"
      redirect_to login_url
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to(root_url) unless current_user? @user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def load_user
      @user = User.find_by id: params[:id]
      return if @user
      redirect_to root_url
      flash[:danger] = t ".notfound"
   end
end
