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
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする。
      redirect_to user
    else
      # エラーメッセージを追加する
      # このフラッシュメッセージは一度表示されると消えずに残ってしまう。
      # リダイレクトを利用した時とはことなり、表示したテンプレートをrenderメソッドで強制的に再レンダリングしても
      # リクエストと見なされないため（なぜ、見なされないのか？）、メッセージは消えない。
      # flash.nowはそのリクエスト内でしか情報を保持しない（その場でエラーを返して終わりたい場合はこちら）
      # flashは次のリクエストまで情報を保持する。（次の画面に情報を保持したい場合に有効）
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destory
    #code
  end
end
