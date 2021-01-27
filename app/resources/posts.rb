module Resources
  class Posts < Grape::API
    helpers do
      params :post do
        requires :post, type: Hash, desc: '文章', documentation: { param_type: 'body' } do
          optional :title, type: String, desc: '标题'
          optional :content, type: String, desc: '内容'
        end
      end
    end

    resource :users do
      route_param :user_id, type: Integer do
        resource :posts do
          route_setting :swagger, root: 'posts'
          desc '查看某个用户的博文',
               tags: ['posts'],
               is_array: true,
               entity: Entities::Post
          get do
            posts = Post.where(user_id: params[:user_id])
            present :posts, posts, with: Entities::Post
          end
        end
      end
    end

    resource :posts do
      route_setting :swagger, root: 'posts'
      desc '查看我的所有博文',
           tags: ['posts'],
           is_array: true,
           entity: Entities::Post
      get do
        authorize User, :login?
        posts = Post.where(user: current_user)
        present :posts, posts, with: Entities::Post
      end

      route_setting :swagger, root: 'post'
      desc '创建新博文',
           tags: ['posts'],
           entity: Entities::Post
      params do
        use :post
      end
      post do
        authorize User, :login?
        post_params = declared(params, include_missing: false)[:post]
        post = Post.new(post_params)
        post.user = current_user
        post.save!
        present :post, post, with: Entities::Post, full: true
      end

      route_param :id, type: Integer do
        route_setting :swagger, root: 'post'
        desc '查看博文',
             tags: ['posts'],
             entity: Entities::Post
        get do
          post = Post.find(params[:id])
          present :post, post, with: Entities::Post, full: true
        end

        desc '更新博文',
             tags: ['posts'],
             entity: Entities::Post
        params do
          use :post
        end
        put do
          post = Post.find(params[:id])
          authorize post, :own?
          post_params = declared(params, include_missing: false)[:post]
          post.update!(post_params)
          present :post, post, with: Entities::Post, full: true
        end

        desc '删除博文',
             tags: ['posts']
        delete do
          post = Post.find(params[:id])
          authorize post, :own?
          post.destroy
          body false
        end
      end
    end
  end
end
