# session_controller.rb
# セッションコントローラーの役割は、サイト会員を管理するためのコントローラーです。
# 新規会員登録、ログイン、ログアウト、永続セッション管理などを行う。
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      remember_or_forget user
      # redirect_to user
      redirect_back_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destory
    log_out if logged_in?
    redirect_to root_url
  end

  private

  # 永続チェックを確認して、永続するかもしくはしないかを決める。
  def remember_or_forget(user)
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  end

end
