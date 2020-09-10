class ChatGroup < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
end
