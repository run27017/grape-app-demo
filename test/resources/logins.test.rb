require_relative '../test_helper'

module Resources
  class LoginsTest < Resources::Test
    def test_login
      user = create(:user)

      post 'logins', { id: user.id }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      assert_equal 200, last_response.status
      assert_equal({ token: user.to_token }.as_json, JSON.parse(last_response.body))
    end
  end
end
