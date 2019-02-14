class UsersController < ApplicationController
  # ユーザーにログインを要求する
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy

  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page])
    # 有効なユーザーのみを表示するように変更しましょう。
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    # このparams[:id]はroutesのurlのuser/:idから取得している。
    if logged_in?
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
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
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # def logged_in_user
  #   unless logged_in?
  #     store_location #
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   end
  # end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
