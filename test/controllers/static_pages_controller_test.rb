require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get static_pages_home_url
    assert_response :success
  end

  # テストで共通するワードがあれば事前に変数を用意することでリファクタリングになる。
  # test_helperでsetupはテスト前に実行されるメソッドなのだろう。
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  # Homeページのテスト。GETリクエストをhomeアクションに対して発行 (=送信) せよ。そうすれば、リクエストに対するレスポンスは[成功]になるはず。
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  # Helpページのテスト
  # GETリクエストをHelpアクションに対して発行（=送信）せよ。
  # そうすれば、リクエストに対するレスポンスは[成功]になるはず。
  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  # Aboutページのテスト
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

end