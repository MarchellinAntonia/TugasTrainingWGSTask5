class Comment < ActiveRecord::Base
validates :article_id, presence: true, length: { minimum: 5 }
validates :user_is, presence: true,length: { minimum: 2 }
validates :content, presence: true
validates :status, presence: true

belongs_to :article
end
