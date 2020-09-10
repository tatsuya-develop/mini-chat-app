require 'rails_helper'

RSpec.describe ChatGroup, type: :model do
  describe 'name' do
    context 'チャットグループ名が空白の場合' do
      it '登録できないこと' do
        chat_group = ChatGroup.new(name: '')

        expect(chat_group).to be_invalid
      end
    end

    context '最大文字数（255文字）を超えた256文字の名前の場合' do
      it '登録出来ないこと' do
        chat_group = ChatGroup.new(name: 'a' *  256)
        
        expect(chat_group).to be_invalid
      end
    end
  end
end
