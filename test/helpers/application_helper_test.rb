require 'test_helper'

# Helper用のテストケース
class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    # full_titleで引数無しのテストケース
    assert_equal full_title, 'Ruby on Rails Tutorial Sample App'
    # full_titleで引数ありのテストケース
    assert_equal full_title("Help"), 'Help | Ruby on Rails Tutorial Sample App'
  end
end
