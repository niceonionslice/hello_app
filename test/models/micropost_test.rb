require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:ai_sakura)
    # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    # 正常な情報を持っているオブジェクトならOKとなること
    assert @micropost.valid?
  end

  test "user id should be present" do
    # マイクロポストはユーザーidは必須なのでエラーになること
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    # コンテンツは空白はだめ
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    # コンテンツは 140文字を超えて登録することはできない。
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
