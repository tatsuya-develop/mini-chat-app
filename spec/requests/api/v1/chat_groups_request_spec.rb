require 'rails_helper'

RSpec.describe "ChatGroups", type: :request do
  describe 'GET #index' do
    context "全てのチャットグループ情報を取得" do
      it 'レスポンスコードが200であること' do 
        create_list(:chat_group, 10)
        get '/api/v1/chat_groups'

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #create' do
    context '登録可能な情報が渡ってきた場合' do
      it '新しいチャットグループを作成する' do
        valid_params = { name: '新しいチャットグループ' }

        # データが作成されていることを確認
        expect { post '/api/v1/chat_groups', params: { chat_group: valid_params } }.to change(ChatGroup, :count).by(+1)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end

      it '最大文字数（255文字）ピッタリの場合' do
        valid_params = { name: '新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ。。' }

        # データが作成されていることを確認
        expect { post '/api/v1/chat_groups', params: { chat_group: valid_params } }.to change(ChatGroup, :count).by(+1)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end
    end

    context '登録不可能な情報が渡ってきた場合' do
      it '最大文字数（255文字）を超えた256文字の名前の場合' do
        # chat_group = ChatGroup.new(name: '新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ新しいチャットグループ。。。')
        chat_group = ChatGroup.new(name: '新しいチャットグループ' *  23 + '１２３') # (11文字 * 23) + 3文字 === 256文字
        
        expect(chat_group).to be_invalid
      end
    end
  end
end
