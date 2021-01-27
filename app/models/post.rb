class Post < ActiveRecord::Base
  belongs_to :user, optional: false
end
