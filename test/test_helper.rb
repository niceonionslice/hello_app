ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # このヘルパーメソッドは、テストのセッションに
  # ユーザがあればtureを返し、なければfalseを返します。
  # ヘルパーメソッドはテストからは呼び出せない（logged_in?メソッドの代わり）
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# 【重要】統合テストでも同様のヘルパーを実装していきます。
# ただし統合テストではsessionを直接取り扱うことができないので、
# 代わりにSessionsリソースに対してpostを送信することで代用します (リスト 8.23)。
# メソッド名は単体テストと同じ、log_in_asメソッドとします。
class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session:
                                { email: user.email,
                                  password: password,
                                  remember_me: remember_me
                                }
                              }
  end
end
