module Api
  module V1
    class ChatGroupsController < ApplicationController
      protect_from_forgery

      def index
        @chat_groups = ChatGroup.all
        render json: @chat_groups
      end
      
      def create
        @chat_group = ChatGroup.new(chat_group_params)
        if @chat_group.save
          render json: @chat_group
        else
          render response_internal_server_error(@chat_group.errors)
        end
      end

      private
        def chat_group_params
          params.require(:chat_group).permit(:name)
        end
    end
  end
end