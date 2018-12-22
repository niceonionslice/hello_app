class ApplicationController < ActionController::Base
  # このヘルパーをインクルードすることでセッションに関するメソッドが全コントローラーで利用することができるようになります。
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

end
