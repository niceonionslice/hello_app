class ApplicationController < ActionController::Base
  # このヘルパーをインクルードすることでセッションに関するメソッドが全コントローラーで利用することができるようになります。
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

  def logged_in_user
    unless logged_in?
      store_location #
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
