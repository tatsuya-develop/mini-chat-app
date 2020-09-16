module Api
  module V1
    class MessagesController < ApplicationController
      protect_from_forgery

      def show
        @message = Message.where(chat_group_id: params['id'])
        render json: @message
      end
    end
  end
end