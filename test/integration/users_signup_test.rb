require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    # get メソッドを使ってユーザー登録ページにアクセスします。
    get signup_path
    # フォーム送信をテストするためには、users_pathに対してpostリクエストを送信する
    # assert_no_differenceは差分がないことを確認するためのメソッド
    # assert_no_differenceメソッドのブロック内でpostを使い、メソッドの引数には'User.count'を与えている。
    # これはassert_no_differenceのブロックを実行する前後で引数の値が変わらないことをテストしている。
    # このテストは、ユーザ数を覚えてた後にデータを投稿してみて、ユーザ数がかわらないかどうかを検証するテストになります。
    assert_no_difference 'User.count' do
      # postメソッドを利用してユーザ登録を行っている。
      # しかし、ユーザーの名前がblankなのでユーザー登録が失敗し、結果としてユーザー登録数は変わらないということになる。
      post users_path, params: {
                          user: {
                            name: "",
                            email: "user@invalid",
                            password: "foo",
                            password_confirmation: "bar"
                          }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    u = User.count
    # assert_difference の第二引数は前後の差分の数をチェックしている。
    # ユーザを新規で登録する。
    assert_difference 'User.count', 1 do
      post users_path, params: {
                          user: {
                            name: "wataru koganei",
                            email: "user@valid.com",
                            password: "wataru",
                            password_confirmation: "wataru"
                          }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert.alert-success'
    assert_not flash.nil?
  end
end
