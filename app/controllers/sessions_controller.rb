class SessionsController < ApplicationController
  def new
  end

  def create
    # paramsの情報はネストしたハッシュになっています
    # { session: { password: "foobar", email: "user@example.com" }}
    # session:
    #   password:
    #   email:
    user = User.find_by(email: params[:session][:email].downcase)
    # user.rbで定義されているhas_secure_passwordがauthenticateメソッドを定義している。
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      # ユーザーログイン後にユーザー情報のページにリダイレクトする。
      redirect_to user
    else
      # エラーメッセージを追加する
      # このフラッシュメッセージは一度表示されると消えずに残ってしまう。
      # リダイレクトを利用した時とはことなり、表示したテンプレートをrenderメソッドで強制的に再レンダリングしても
      # リクエストと見なされないため、メッセージは消えない。
      # flash.nowはそのリクエスト内でしか情報を保持しない（その場でエラーを返して終わりたい場合はこちら）
      # flashは次のリクエストまで情報を保持する。（次の画面に情報を保持したい場合に有効）
      # ridirect --------> request -----> respons 再レンダリングが発生する。
      # flash -------> respons リクエストとみなされないため 再レンダリングが発生しない。
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destory
    log_out if logged_in?
    redirect_to root_url
  end
end
