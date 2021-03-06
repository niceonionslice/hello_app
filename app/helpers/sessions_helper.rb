# session_helper.rb
# セッションコントローラーの処理で複雑な処理についてヘルパーを利用している。
# セッションコントローラーに情報を全部書くとそれだけでコントローラーが肥大化してしまうので
# セッションヘルパーに細かい処理を持ってくることでコントローラーをスリムにしている。
module SessionsHelper

  # 渡されたユーザでログインする
  # セッションにユーザIDを格納します。
  # sessionオブジェクトに登録されるとcookieに値が格納される
  # 格納される時には暗号化されます。
  def log_in(user)
    session[:user_id] = user.id
  end

  # 記憶トークンcookieに対応するユーザを返す
  # セッションに登録されていたら。。
  # クッキーに登録されていたら。。
  # クッキーから認証トークンを取得
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザのセッションを永続的にする
  # permanent = 永続的なという意味
  # 20.years.from_now という設定を permanentメソッドは行っている。
  # signed メソッドで暗号化
  # cookieから取得する方法は User.find_by(id: cookies.signed[:user_id])
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # ユーザが存在していない場合nilが返却される。このメソッドではログインしているかを問い合わせているのでログインしていない場合はfalseを返却しなければならない。
  # !をつけることでtrue / falseが逆になります。
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザをログアウトする
  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end


  # フレンドリーフォワーディングを実装

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_to(defalut)
    redirect_to(session[:forwarding_url] || defalut)
    # 転送用のURLを削除する。
    # この処理を、実施しておくことで次回ログインした時に保護されたページに転送されてしまい、
    # ブラウザを閉じるまで処理がくりかえされてしまう。
    session.delete(:forwarding_url)
  end

  # アクセスしてきたURLを覚えておく
  # getの時だけ保存するようにします。
  # 例えばログインしていないユーザがフォームを作って送信（不正）した場合、
  # 転送先のURLを保存させないようにできる。
  def store_location
    # リクエストがgetの場合
    # リクエスト先のURLを取得してsessionに登録しておく。
    # request.original_urlでリクエスト先が取得できます。
    session[:forwarding_url] = request.original_url if request.get?
  end

  def current_user_is_admin_and_current_user?(user)
    current_user.admin? && !current_user?(user)
  end

  private

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
