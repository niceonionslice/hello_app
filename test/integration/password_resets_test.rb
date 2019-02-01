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
  end
end
