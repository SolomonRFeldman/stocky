class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    user.save ? render(json: user.login_hash, status: 200) : render(json: { errors: user.errors }, status: 400 )
  end

  def show
    if @current_user_id == params[:id].to_i
      return render status: 200
    end
    render status: 400
  end

  private
 
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end