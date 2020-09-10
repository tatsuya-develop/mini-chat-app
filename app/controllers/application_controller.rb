class ApplicationController < ActionController::Base
  # 500 Internal Server Error
  def response_internal_server_error(errors)
    render json: { message: errors.full_messages[0] }, status: 500
  end
end
