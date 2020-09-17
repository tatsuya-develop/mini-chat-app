require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'body' do
    before do
      @chat_group = create(:chat_group, name: '新しいチャットグループ')
    end

    context 'メッセージ内容が空白の場合' do
      it '登録できないこと' do
        message = Message.new(chat_group_id: @chat_group.id, body: '')

        expect(message).to be_invalid
      end
    end

    context '最大文字数（255文字）を超えた256文字のメッセージ内容の場合' do
      it '登録出来ないこと' do
        message = Message.new(chat_group_id: @chat_group.id, body: 'a' *  256)
        
        expect(message).to be_invalid
      end
    end
  end

  describe 'chat_group_id' do
    context 'メッセージ内容が空白の場合' do
      it '登録できないこと' do
        message = Message.new(body: 'a' *  256)

        expect(message).to be_invalid
      end
    end

    context '最大文字数（255文字）を超えた256文字のメッセージ内容の場合' do
      it '登録出来ないこと' do
        message = Message.new(body: 'a' *  256)
        
        expect(message).to be_invalid
      end
    end
  end
end
