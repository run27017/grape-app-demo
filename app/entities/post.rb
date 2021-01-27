module Entities
  class Post < Grape::Entity
    expose :id, documentation: { type: 'integer', desc: '博文 id' }
    expose :title, documentation: { type: 'string', desc: '标题' }
    expose :content, if: { full: true }, documentation: { type: 'string', desc: '正文内容' }
    expose :user_id, documentation: { type: 'integer', desc: '用户 id' }
  end
end
