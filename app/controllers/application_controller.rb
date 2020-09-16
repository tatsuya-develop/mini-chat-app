class ApplicationController < ActionController::Base

  MESSAGE_INTERNAL_SERVER_ERROR = 'システム側でエラーが発生しました。管理者にご連絡ください。'

  # 400 Bad Request
  def response_bad_request(errors)
    render json: { message: errors.full_messages[0] }, status: 400
  end

  # 500 Internal Server Error
  def response_internal_server_error(errors)
    # バックエンド側はログに詳細を吐き、フロントエンド側に返すメッセージはシンプルなものにする
    logger.error(errors)
    render json: { message: MESSAGE_INTERNAL_SERVER_ERROR }, status: 500
  end
end
