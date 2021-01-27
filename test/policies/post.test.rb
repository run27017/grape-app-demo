require_relative '../test_helper'

class PostPolicyTest < Models::Test
  def test_own_policy
    post = create(:post)
    another_user = create(:user)

    assert Pundit.policy(post.user, post).own?
    assert !Pundit.policy(nil, post).own?
    assert !Pundit.policy(another_user, post).own?
  end
end
