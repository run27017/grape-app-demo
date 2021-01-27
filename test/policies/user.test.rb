require_relative '../test_helper'

class UserPolicyTest < Models::Test
  def test_login_policy
    user = create(:user)
    assert Pundit.policy(user, User).login?
    assert !Pundit.policy(nil, User).login?
  end
end
