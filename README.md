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

## 永続的セッションを作成する手順

1. 記憶トークンにはランダムな文字列を生成して用いる
2. ブラウザのcookieにトークンを保存するときには、有効期限を設定する
3. トークンはハッシュ値に変換してからデータベースに保存する
4. ブラウザのcookieに保存するユーザidは暗号化しておく。
5. 永続ユーザーIDを含むcookieを受け取ったら、そのIDでデータベースを検索し、記憶トークンのcookiesがデータベース内のハッシュ値と一致することを確認する。

永続的なセッションを作成する場合はモデルにremenber_digestを追加して記憶トークンとの照合に利用する。


### ブラウザによくある問題について対応する。

同一ブラウザで複数タブを開いてみる
異なるブラウザで同一サービスを開いてみる

ログアウトを行った後に別のタブから再度ログアウトしようとするとすでに
ログアウトしているたのでcurrent_userがnilになってしまうためシステムとしては
矛盾が起きてしまいシステムエラーになってしまいます。
この問題を解決するにはcurrent_userが存在している場合のみlog_out処理をすることが望ましい。
