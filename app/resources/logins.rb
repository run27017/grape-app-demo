module Resources
  class Logins < Grape::API
    class TokenEntity < Grape::Entity
      expose :token, documentation: { type: String, desc: '用以验证用户身份的 API token' }
    end

    resource :logins do
      desc '登录',
           entity: TokenEntity
      params do
        requires :id, type: Integer, desc: '使用用户 id 登录'
      end
      post do
        user = User.find(params[:id])

        status 200
        return { token: user.to_token }
      end
    end
  end
end
