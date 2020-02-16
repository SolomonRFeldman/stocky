class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    user.save ? render(json: user.login_hash, status: 200) : render(json: { errors: user.errors }, status: 400 )
  end

  def show
    if @current_user_id == params[:id].to_i
      user = User.find_by(id: @current_user_id)
      user_stocks = UserStock.with_prices(UserStock.where(user_id: params[:id]))
      user_stock_histories = UserStockHistory.with_symbol(UserStockHistory.where(user_id: params[:id]))
      return render json: { balance: user.balance, user_stocks: user_stocks, user_stock_histories: user_stock_histories }, status: 200
    end
    render status: 400
  end

  private
 
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end