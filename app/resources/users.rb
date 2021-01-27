module Resources
  class Users < Grape::API
    helpers do
      params :user do
        requires :user, type: Hash, desc: '用户', documentation: { param_type: 'body' } do
          optional :name, type: String, desc: '姓名'
          optional :age, type: Integer, desc: '年龄'
        end
      end
    end

    resource :users do
      route_setting :swagger, root: 'users'
      desc '返回所有用户',
           tags: ['users'],
           entity: Entities::User,
           is_array: true
      get do
        users = User.all
        present :users, users, with: Entities::User
      end

      route_setting :swagger, root: 'user'
      desc '注册新用户',
           tags: ['users'],
           entity: Entities::User
      params do
        use :user
      end
      post do
        user_params = declared(params, include_missing: false)[:user]
        user = User.create!(user_params)
        present :user, user, with: Entities::User
      end
    end

    resource :user do
      route_setting :swagger, root: 'user'
      desc '查看我的信息',
           tags: ['users'],
           entity: Entities::User
      get do
        authorize User, :login?
        present :user, current_user, with: Entities::User
      end

      route_setting :swagger, root: 'user'
      desc '更新我的信息',
           tags: ['users'],
           entity: Entities::User
      params do
        use :user
      end
      put do
        authorize User, :login?
        user_params = declared(params, include_missing: false)[:user]
        current_user.update!(user_params)
        present :user, current_user, with: Entities::User
      end
    end
  end
end
