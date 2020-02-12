class ApplicationController < ActionController::API
  before_action :fetch_current_user

  def fetch_current_user
    decoded_hash = JwtService.decode(request.headers[:Token])
    @current_user_id = decoded_hash[:user_id] if decoded_hash
  end

end
