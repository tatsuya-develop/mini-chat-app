class ChatGroup < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
