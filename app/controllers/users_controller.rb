class UsersController < ApplicationController
  # ユーザーにログインを要求する
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only:[:edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    # このparams[:id]はroutesのurlのuser/:idから取得している。
    if logged_in?
      @user = User.find(params[:id])
    else
      flash[:warning] = 'アカウントをお持ちの方はログインして下さい。お持ちでない方は新規アカウント登録をお願いします。'
      redirect_to root_url
    end
    # debugger
  end

  def create
    # createは、ユーザー登録時に呼ばれる
    @user = User.new(user_params) # 実装は終わっていないことに注意！
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      # 以下のコードは redirect_to user_url(user) 等価
      #  Railsがよしなにコードを理解してくれている。
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      #更新に成功した場合を扱う。
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location #
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
