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
    context '登録が成功する場合' do
      it '登録後の値と200を返すこと' do
        valid_params = { name: '新しいチャットグループ' }

        # データが作成されていることを確認
        expect { post api_v1_chat_groups_path, params: { chat_group: valid_params } }.to change(ChatGroup, :count).by(+1)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end
    end

    context '最大文字数（255文字）ピッタリの値で登録が成功する場合' do
      it '登録後の値と200を返すこと' do
        valid_params = { name: 'a' * 255 }

        # データが作成されていることを確認
        expect { post api_v1_chat_groups_path, params: { chat_group: valid_params } }.to change(ChatGroup, :count).by(+1)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)
      end
    end

    context '登録が失敗する場合' do
      it 'エラーメッセージと400を返すこと' do
        invalid_params = { name: 'a' * 256 }

        post api_v1_chat_groups_path, params: { chat_group: invalid_params }

        # Bad Request を表す400が返ってきたかを確認する。
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'PUT #update' do
    context '更新が成功する場合' do
      it '更新後の値と200を返すこと' do
        current_chat_group = create(:chat_group, name: '新しいチャットグループ')
        updated_chat_group = '新しいチャットグループ_更新後';
        valid_params = { name: updated_chat_group }

        put api_v1_chat_group_path(current_chat_group.id), params: { chat_group: valid_params }
        json = JSON.parse(response.body)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)

        # データが更新されていることを確認
        expect(current_chat_group.reload.name).to eq updated_chat_group
      end
    end

    context '最大文字数（255文字）ピッタリの値で更新が成功する場合' do
      it '更新後の値と200を返すこと' do
        current_chat_group = create(:chat_group, name: '新しいチャットグループ')
        updated_chat_group = 'a' * 255;
        valid_params = { name: updated_chat_group }

        put api_v1_chat_group_path(current_chat_group.id), params: { chat_group: valid_params }
        json = JSON.parse(response.body)

        # リクエスト成功を表す200が返ってきたかを確認する。
        expect(response.status).to eq(200)

        # データが更新されていることを確認
        expect(json['name']).to eq(updated_chat_group)
      end
    end

    context '更新が失敗する場合' do
      it 'エラーメッセージと400を返すこと' do
        current_chat_group = create(:chat_group, name: '新しいチャットグループ')
        updated_chat_group = 'a' * 256;
        invalid_params = { name: updated_chat_group }

        put api_v1_chat_group_path(current_chat_group.id), params: { chat_group: invalid_params }

        # Bad Request を表す400が返ってきたかを確認する。
        expect(response.status).to eq(400)
      end
    end
  end
end
