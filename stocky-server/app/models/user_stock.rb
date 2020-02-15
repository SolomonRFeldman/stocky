class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  class << self
  
    def find_or_create_by_symbol(user_id: nil, stock_symbol: nil)
      user_stock = 
        UserStock
          .joins('JOIN stocks ON user_stocks.stock_id = stocks.id')
          .where("user_id = ? AND stocks.symbol = ?", user_id, stock_symbol)
          .first
      user_stock ? user_stock : UserStock.create(user_id: user_id, stock_id: Stock.find_by(symbol: stock_symbol).id)
    end

  end

end