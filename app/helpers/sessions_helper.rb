module SessionsHelper

  # 渡されたユーザでログインする
  def log_in(user)
    # セッションにユーザIDを格納します。
    # sessionオブジェクトに登録されるとcookieに値が格納される
    # 格納される時には暗号化されます。
    session[:user_id] = user.id
  end

  # セッションに登録されているユーザIDを利用して現在ログイン中のユーザ情報を取得する。
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザのセッションを永続的にする
  def remember(user)
    user.remember
    # permanent = 永続的なという意味
    # 20.years.from_now という設定を permanentメソッドは行っている。
    # signed メソッドで暗号化
    # cookieから取得する方法は User.find_by(id: cookies.signed[:user_id])
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザを返す
  def current_user
    # セッションに登録されていたら。。
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # クッキーに登録されていたら。。
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # クッキーから認証トークンを取得
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    # ユーザが存在していない場合nilが返却される。このメソッドではログインしているかを問い合わせているのでログインしていない場合はfalseを返却しなければならない。
    # !をつけることでturu / falseが逆になります。
    !current_user.nil?
  end


  # 現在のユーザをログアウトする
  def log_out
    forget current_user
    @current_user = nil
  end

  private

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
    session.delete :user_id
  end
end
