require_relative '../test_helper'

module Resources
  class UsersTest < Resources::Test
    def setup
      super # 重要
      @user = create(:user)
    end

    def test_get_all
      user2 = create(:user)

      get 'users'
      assert last_response.ok?
      assert_equal [@user, user2], presents(:users)
    end

    def test_create
      post 'users',
           { user: attributes_for(:user, name: 'xiaohuang') }.to_json,
           { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.created?
      assert_equal 'xiaohuang', presents(:user).name
    end

    def test_show_myself
      header 'X-Token', @user.to_token
      get 'user'
      assert_equal @user, presents(:user)
    end

    def test_update_myself
      header 'X-Token', @user.to_token
      put 'user', { user: { name: 'xiaohuang', age: 20 } }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.ok?
      assert_equal 'xiaohuang', presents(:user).name
      assert_equal 20, presents(:user).age
    end
  end
end
