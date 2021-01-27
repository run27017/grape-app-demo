module Entities
  class User < Grape::Entity
    expose :id, documentation: { type: 'integer', desc: '用户 id' }
    expose :name, documentation: { type: 'string', desc: '姓名' }
    expose :age, documentation: { type: 'integer', desc: '年龄' }
  end
end
