require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe 'GET #show' do
    context "チャットグループIDに紐づくメッセージ情報を取得" do
      it 'レスポンスコードが200であること' do 
        chat_group = create(:chat_group, name: '新しいチャットグループ')
        create_list(:message, 5, chat_group_id: chat_group.id)

        get api_v1_message_path(chat_group.id)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end
    end
  end
end
