class SessionsController < ApplicationController

  def create
    unless @current_user_id && user = User.find_by(id: @current_user_id)
      unless params[:user] && user = User.authenticate(email: params[:user][:email], password: params[:user][:password])
        return render json: { authentication_error: true }, status: 400
      end
    end
    render json: user.login_hash
  end

end