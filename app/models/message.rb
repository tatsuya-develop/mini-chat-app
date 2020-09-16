class Message < ApplicationRecord
  belongs_to :chat_group

  validates :body, presence: true, length: { maximum: 255 }
end
