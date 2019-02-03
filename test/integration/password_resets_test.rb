require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:ai_sakura)
  end

  test "password resets" do
    # ここから続きを書きます。
    # 割と長いテストコードをこれから記述することになります。
    # テストをしっかりしてこそコードの品質を保つことができます。
    # 頑張れ！頑張れ！
    # https://railstutorial.jp/chapters/password_reset?version=5.1#sec-password_reset_test
    # 12.18から

    get new_password_reset_url
    assert_template 'password_resets/new'

    # メールアドレス無効
    post password_resets_path, params:{password_reset:{email: ""}}
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # メールアドレス有効
    post password_resets_path, params:{password_reset:{email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # パスワード再設定フォームのテスト
    user = assigns(:user)

    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email:"")
    assert_not flash.empty?
    assert_redirected_to root_url

    # 無効なユーザー
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_not flash.empty?
    assert_redirected_to root_url
    user.toggle!(:activated)

    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_not flash.empty?
    assert_redirected_to root_url

    # メールアドレスもトークンも有効
     get edit_password_reset_path(user.reset_token, email: user.email)
     assert_template 'password_resets/edit'
     # inputタグがあるのかどうかを確認する下記のコードはこのようなコードがあることを確認している。
     # <input id='email' name='email' type='hidden' value="{{user.email}}"
     assert_select "input[name=email][type=hidden][value=?]", user.email

     # 無効なパスワードとパスワード確認
     patch password_reset_path(user.reset_token),
      params:{ email: user.email,
                user: {password: "foobar",
                       password_confirmation: "barquux"}}
     assert_select 'div#error_explanation'

     # パスワードが空
     patch password_reset_path(user.reset_token),
     params:{ email: user.email,
               user: {password: "",
                      password_confirmation: ""}}
     assert_select 'div#error_explanation'

     # 有効なパスワードとパスワード確認
     patch password_reset_path(user.reset_token),
      params: {email: user.email,
              user: { password: "foobar",
                      password_confirmation: "foobar" }}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end


  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: {password_reset: { email: @user.email }}

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)

    patch password_reset_path(@user.reset_token),
      params:{ email: @user.email,
        user: { password: "foobar",
                password_confirmation: "foobar" }}
    assert_response :redirect
    follow_redirect!
    # 正規表現を利用して本文に特定の文字列が含まれていないかを確認
    assert_match /expired/i, response.body
  end

  # パスワードリセットするための画面ではhiddonでメールアドレスを持っているがinputの定義では[name=email]と定義しているのでパラメータで取得するときには
  # params { email: hogehoge} という感じで取得する。
  # パスワードは新しいパスワードと再入力用のパスワードが存在しておりまたユーザーに紐付いていることから
  # params { user: { password: hogehoge, password_confirmation: hogehoge}} と定義する必要がある。

  # <form
  #   class="edit_user"
  #   id="edit_user_1"
  #   action="/password_resets/1foNqAT7v_0C--x4_DtoNQ"
  #   accept-charset="UTF-8"
  #   method="post">
  #
  #   <input name="utf8" type="hidden" value="✓">
  #   <input type="hidden" name="_method" value="patch">
  #   <input type="hidden" name="authenticity_token" value="vBWXuzIiZ7BA3Ob4LEJiVREuNdakkhiPESR+FLOm3xYBjChLsqjzt8k1RqJDKto1+7iT7Yk9YRPRP4lFX/i3OQ==">
  #   <input type="hidden" name="email" id="email" value="ichi_taro@example.org">
  #
  #   <label for="user_password">Password</label>
  #   <input class="form-control" type="password" name="user[password]" id="user_password" aria-autocomplete="list">
  #
  #   <label for="user_password_confirmation">Confirmation</label>
  #   <input class="form-control" type="password" name="user[password_confirmation]" id="user_password_confirmation">
  #
  #   <input type="submit" name="commit" value="Update password" class="btn btn-primary" data-disable-with="Update password">
  # </form>
end
