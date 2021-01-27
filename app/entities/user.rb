module Entities
  class User < Grape::Entity
    expose :id, documentation: { type: Integer, desc: '用户 id' }
    expose :name, documentation: { type: String, desc: '姓名' }
    expose :age, documentation: { type: Integer, desc: '年龄' }
  end
end
