require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ai_sakura)
  end

  # テストユーザーでログインする
  # 編集モードはログインしないとテストできないよ。
  test "unsuccessful edit" do
    log_in_as(@user) # ログイン
    get edit_user_path(@user) # 編集ページにアクセス
    assert_template 'users/edit' # 編集ページに飛んでいることを確認する。
    patch user_path(@user), params: { user: # 無効な情報でユーザ情報をupdateする。
                                        {
                                          name: "",
                                          email: "foo@invalid",
                                          password: "foo",
                                          password_confirmation: "bar"
                                        }
                                    }
    assert_template 'users/edit' # editが再描画されていることを確認
    assert flash.empty? # 再描画でflashが表示されていることを確認
    assert_select 'title', full_title("Edit user")
    assert_select'body div.alert'
  end


  # 編集モードはログインしないとテストできないよ。
  test "successful edit" do
    log_in_as(@user) # ログイン
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
                                      user: {
                                        name: name,
                                        email: email,
                                        password: "",
                                        password_confirmation: ""
                                      }
                                    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # フレンドリーフォワーディングとは、ユーザがログインする前にいた画面に
  # ログイン後にリダイレクトしてあげることをいいます。（つまり、親切な機能）
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], "http://www.example.com#{edit_user_path(@user)}"
    log_in_as(@user) # ログイン
    assert_redirected_to edit_user_url(@user) # リダイレクト先を検証
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
                                      user: {
                                        name: name,
                                        email: email,
                                        password: "",
                                        password_confirmation: ""
                                      }
                                    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert session[:forwarding_url].nil?
  end
end
