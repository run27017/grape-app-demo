module Entities
  class Post < Grape::Entity
    expose :id, documentation: { type: Integer, desc: '博文 id' }
    expose :title, documentation: { type: String, desc: '标题' }
    expose :content, if: { full: true }, documentation: { type: String, desc: '正文内容' }
    expose :user_id, documentation: { type: Integer, desc: '用户 id' }
  end
end
