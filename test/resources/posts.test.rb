require_relative '../test_helper'

module Resources
  class PostsTest < Resources::Test
    def setup
      super # 重要
      @post = create(:post)
      @user = @post.user
    end

    def test_list_my_own
      user = create(:user)
      posts = create_list(:post, 3, user: user)
      create_list(:post, 2)

      header 'X-Token', user.to_token
      get 'posts'
      assert last_response.ok?
      assert_equal(posts.map(&:id), last_response_json['posts'].map{ |it| it['id'] })
    end

    def test_list_of_specified_user
      user = create(:user)
      posts = create_list(:post, 3, user: user)
      create_list(:post, 2)

      get "users/#{user.id}/posts"
      assert last_response.ok?
      assert_equal(posts.map(&:id), last_response_json['posts'].map{ |it| it['id'] })
    end

    def test_create
      header 'X-Token', @user.to_token
      post 'posts',
           { post: attributes_for(:post, title: 'new post') }.to_json,
           { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.created?
      assert_equal 'new post', last_response_json['post']['title']
    end

    def test_show
      get "posts/#{@post.id}"
      assert last_response.ok?
      assert_equal 1, last_response_json['post']['id']
    end

    def test_update
      header 'X-Token', @user.to_token
      put "posts/#{@post.id}",
          { post: { title: 'title updated', content: 'content updated' } }.to_json,
          { 'CONTENT_TYPE' => 'application/json' }
      assert last_response.ok?
      assert_equal 'title updated', last_response_json['post']['title']
      assert_equal 'content updated', last_response_json['post']['content']
    end

    def test_destroy
      header 'X-Token', @user.to_token
      delete "posts/#{@post.id}"
      assert last_response.no_content?
      assert !Post.where(id: 1).exists?
    end
  end
end
