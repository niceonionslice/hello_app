require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # routesを修正して名前付きルートに変更したので 'login_path' に変更
    get login_path
    assert_response :success
  end

end
