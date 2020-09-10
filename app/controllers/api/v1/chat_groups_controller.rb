module Api
  module V1
    class ChatGroupsController < ApplicationController
      protect_from_forgery

      before_action :set_target_chat_group, only: %i[update]

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
      
      def update
        if @chat_group.update(chat_group_params)
          render json: @chat_group
        else
          render response_internal_server_error(@chat_group.errors)
        end
      end

      private
        def chat_group_params
          params.require(:chat_group).permit(:name)
        end

        def set_target_chat_group
          @chat_group = ChatGroup.find(params[:id])
        end
    end
  end
end