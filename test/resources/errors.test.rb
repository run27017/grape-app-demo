require_relative '../test_helper'

module Resources
  class ErrorsTest < Resources::Test
    def test_route_error
      get '/error_path'
      assert last_response.not_found?
      assert_equal 'route_not_found', JSON.parse(last_response.body)['code']
    end

    def test_resource_not_found
      get 'posts/0'
      assert last_response.not_found?
      assert_equal 'resource_not_found', JSON.parse(last_response.body)['code']
    end

    def test_parameter_invalid
      post 'users', {}.to_json, { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.bad_request?
      assert_equal 'parameter_invalid', JSON.parse(last_response.body)['code']
    end

    def test_constraint_broken
      post 'users', { user: {} }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.unprocessable?
      assert_equal 'resource_invalid', JSON.parse(last_response.body)['code']
    end

    def test_not_authorized
      post = create(:post)
      user = create(:user)

      header 'X-Token', user.to_token
      put "posts/#{post.id}",
          { post: { title: 'title updated', content: 'content updated' } }.to_json,
          { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.forbidden?
      assert_equal 'not_authorized', JSON.parse(last_response.body)['code']
    end

    # 测试其他的未知异常
    # def test_all_error
    #   User.delete_all
    #   post 'logins'
    #   assert last_response.server_error?
    # end
  end
end
