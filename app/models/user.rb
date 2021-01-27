class User < ActiveRecord::Base
  validates :name, presence: true

  def to_token
    Token.encode(self.id)
  end

  def self.from_token(token)
    Token.decode(token)
  end
end
