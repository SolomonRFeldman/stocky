class UserStockHistory < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  def with_symbol
    self
      .attributes
      .slice("id", "shares", "price")
      .merge("symbol" => self.stock.symbol)
  end

  class << self

    def with_symbol(user_stock_histories)
      user_stock_histories
        .joins('JOIN stocks ON user_stock_histories.stock_id = stocks.id')
        .select(:id, :symbol, :shares, :price)
    end

  end
end