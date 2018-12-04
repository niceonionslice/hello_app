require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name:"Example User", email: "user@exsample.com")
  end

  test "should valid" do
    assert @user.valid?
  end
end
