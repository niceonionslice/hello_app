class PasswordResetsController < ApplicationController
  before_action :get_user, only:[:edit, :update]
  before_action :valid_user, only:[:edit, :update]
  before_action :check_expiration, only:[:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_rest_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    # このメソッドは特に何もしていない。がこのeditが呼ばれるのはメールからなのだ。
    # このメソッドのviewはMailerなのだ。
  end

  def update
    # このメソッドはパスワードリセットする時に呼ばえる
    # メールで送信されたURLに記載されている。
    # パラメータで渡されるパスワードがNULLもしくは空の場合はエラーとする
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      # log_inを利用することでログイン状態にすることができる。
      log_in @user
      flash[:success] = "Password has been reset."
      # ログインしたとは転送でマイページに遷移してもらう。
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      # ユーザー情報がinvalidだった時にはrootにリダイレクトする
      redirect_to root_url
    end
  end

  # 1. パスワード再設定の有効期限が切れていないか
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired" # expired = 終了するの意
      redirect_to new_password_reset_url
    end
  end
end

# 12.6 から続きをしましょう。
# https://railstutorial.jp/chapters/password_reset?version=5.1#table-RESTful_password_resets
