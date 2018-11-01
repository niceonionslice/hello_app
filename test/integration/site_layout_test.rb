# full_titleを利用するためにrequire 'test_helper'を宣言
require 'test_helper'

# このテストは、、、
# リンクのテスト
# レイアウト内のリンクが正しく動いているのかを確認するためのテスト
# 統合テスト (Integration Test)」を使って一連の作業を自動化。
# 統合テストを使うと、アプリケーションの動作を端から端まで (end-to-end) シミュレートしてテストすることができます。
# $ rails generate integration_test site_layout
# $ rails test:integration
class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    # -----------------------------------
    # 1. ルートURL(Homeページ)にGETリクエストを送る
    # 2. 正しくページテンプレートが描画されているか確認
    # 3. Home, Help, About, Contactの各ページのリンクが正しく動くか確認
    # -----------------------------------
    get root_path
    assert_template 'static_pages/home'
    # ?の部分が root_path で置換されていて、それがサイトに存在するのかを確認している。
    # count: はそれが２つ存在していることを確認している。
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path
    get contact_path # 画面遷移かな
    assert_select 'title', full_title("Contact") # helperメソッドの結果と比べてる
  end

  test "Signup layout" do
    get signup_path
    assert_template 'users/new'
    assert_select 'title', full_title("Sign up") # helperメソッドの結果と比べてる
  end
end

# メモ：
# 一般的な規約に従うなら、基本的には_pathを利用する。リダイレクトの指定の場合は_urlを利用する。
