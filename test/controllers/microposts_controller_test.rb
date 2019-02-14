require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    #code
    @user = users(:ai_sakura)
    @micropost = microposts(:orange)
  end


  # Micropostsリソースを開発では、Micropostsコントローラ内のアクセス制御から始めることになります。
  # 関連付けされたユーザーを通してマイクロポストにアクセスするので、createアクションやdestroyアクションを
  # 利用するユーザーは、ログイン済みでなければなりません。

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count', -1 do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" }}
    end
    assert_redirected_to login_url
  end

  test "should redirect destory when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@user)
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end
