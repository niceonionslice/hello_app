require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:ai_sakura)
  end


  test "login with invalid infomation" do
    # 1. ログインパスを開く
    # 2. 新しいセッションのフォームが正しく表示されていることを確認
    # 3. わざと無効なparamsハッシュを使ってセッションパスにPOSTする
    # 4. 新しいセッションのフォームが再度表示され、フラッシュメッセージが追加されていることを確認する。
    # 5. 別のページに一旦移動
    # 6. 異動先のページでフラッシュメッセージが表示されていないことを確認する
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session: { email: "", password: "" }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?

    get login_path
    assert_template 'sessions/new'
    assert flash.empty?
    post login_path, params: { session: { email: "", password: "" }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # 1. ログイン用のパスを開く
  # 2. セッション用パスに有効な情報をpostする
  # 3. ログイン用リンクが表示されなくなったことを確認する
  # 4. ログアウト用リンクが表示されていることを確認する
  # 5. プロフィール用リンクが表示されていることを確認する
  test "login with valid infomation" do
    assert_selects
  end


  test "login with valid infomation follow by logout" do
    assert_selects

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # ２番目のウィンドウでログアウトをクリックするユーザをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0;
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  def assert_selects
    get login_path
    post login_path, params: set_login_params
    assert_redirected_to @user # リダイレクト先を検証
    follow_redirect! # リダイレクト
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  def set_login_params
    {
      session: {
        email: @user.email,
        password: 'password'
      }
    }
  end
end
