module SessionsHelper
  def log_in(user)
    # セッションにユーザIDを格納します。
    # sessionオブジェクトに登録されるとcookieに値が格納される
    # 格納される時には暗号化されます。
    session[:user_id] = user.id
  end

  # セッションに登録されているユーザIDを利用して現在ログイン中のユーザ情報を取得する。
  def current_user
    # if session[:user_id] # ifがfalseの場合は自動的にこのメソッドはnilを返す。
    #   User.find_by(id: session[:user_id])
    # end
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # ユーザが存在していない場合nilが返却される。このメソッドではログインしているかを問い合わせているのでログインしていない場合はfalseを返却しなければならない。
    # !をつけることでturu / falseが逆になります。
    !current_user.nil?
  end

  def log_out
    session.delete :user_id
    @current_user = nil
    redirect_to root_url
  end
end
