class UserStocksController < ApplicationController

  def create
    if @current_user_id == params[:user_id].to_i
      user_stock = UserStock.find_or_new_by_symbol(user_id: params[:user_id], stock_symbol: params[:user_stock][:symbol])
      user_stock.shares += params[:user_stock][:shares].to_i
      user_stock.save
      return render json: { 
        new_balance: user_stock.user.balance, 
        **user_stock.with_prices, 
        user_stock_history: user_stock.last_history.with_symbol 
      }, status: 200
    end
    render status: 400
  end

end