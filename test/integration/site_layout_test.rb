require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout links" do
    get root_path #画面遷移かな
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path
    get contact_path # 画面遷移かな
    assert_select 'title', full_title("Contact") # helperメソッドの結果と比べてる
  end
end
