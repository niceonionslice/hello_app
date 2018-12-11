class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    # このparams[:id]はroutesのurlのuser/:idから取得している。
    @user = User.find(params[:id])
    # debugger
  end

  def create
    # createは、ユーザー登録時に呼ばれる
    @user = User.new(user_params) # 実装は終わっていないことに注意！
    if @user.save
      # 保存の成功をここで扱う。
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
