module Resources
  class Users < Grape::API
    helpers do
      params :user do
        requires :user, type: Hash, desc: '用户', documentation: { param_type: 'body' } do
          optional :all, using: Entities::User.to_params.except(:id)
        end
      end
    end

    resource :users do
      desc '返回所有用户',
           tags: ['users']
      status 200 do
        expose :users, using: Entities::User, documentation: { is_array: true }
      end
      get do
        users = User.all
        present :users, users
      end

      desc '注册新用户',
           tags: ['users']
      params do
        use :user
      end
      status 201 do
        expose :user, using: Entities::User
      end
      post do
        user_params = declared(params, include_missing: false)[:user]
        user = User.create!(user_params)
        present :user, user
      end
    end

    resource :user do
      desc '查看我的信息',
           tags: ['users']
      status 200 do
        expose :user, using: Entities::User
      end
      get do
        authorize User, :login?
        present :user, current_user
      end

      desc '更新我的信息',
           tags: ['users'],
           entity: Entities::User
      params do
        use :user
      end
      status 200 do
        expose :user, using: Entities::User
      end
      put do
        authorize User, :login?
        user_params = declared(params, include_missing: false)[:user]
        current_user.update!(user_params)
        present :user, current_user
      end
    end
  end
end
