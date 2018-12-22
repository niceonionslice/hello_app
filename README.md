# Ruby on Rails チュートリアルのサンプルアプリケーション

ログインとログアウトの要素を、Sessionsコントローラの特定のRESTアクションにそれぞれ対応付けることにします。
ログインのフォームは、この節で扱うnewアクションで処理します。
createアクションにpostリクエストを送信すると、実際にログインします。
destoryアクションにDELETEリクエストを送信すると、ログアウトします。

ログインでセッションを作成する場合に最初に行うのは、入力が無効な場合の処理。
最初に、フォームが送信された時の動作を順を追って理解する必要がある。
次に、ログインが失敗した場合に表示されるエラーメッセージを配置します。
それから、ログインに成功した場合に使う土台部分を作成します。
このチュートリアルでは、メールアドレスとパスワードの組み合わせが有効かを判定する。


miniTestを利用する場合のテストの書き方

特定のページを開く
get login_path
get user_path
get root_path

画面のテンプレート（つまりどの画面が開いているか）
assert_template "users/show"
assert_template "sessions/new"

画面に表示されている。されていない。要素を確認する
assert_select "a[href=?]", login_path, count: 0
assert_select "a[href=?]", logout_path
assert_select "a[href=?]", user_path(@user)

assert_not flash.empty?
assert_not @user.valid?

リダイレクト先を確認する
assert_redirected_to @user
検証先のリダイレクト先へ移動する
follow_redirect
