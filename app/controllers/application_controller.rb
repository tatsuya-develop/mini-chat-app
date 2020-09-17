class ApplicationController < ActionController::Base

  # 400 Bad Request
  def response_bad_request(errors)
    render json: { message: errors.full_messages[0] }, status: 400
  end

  # 500 Internal Server Error
  def response_internal_server_error(errors)
    logger.error(errors)
    render json: { message: errors.full_messages[0] }, status: 500
  end
end
