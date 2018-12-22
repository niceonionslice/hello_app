require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
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
end
