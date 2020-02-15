class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  before_update do
    diff = self.shares - UserStock.find(self.id).shares
    if diff != 0
      api_key = Rails.application.credentials[Rails.env.to_sym][:iex_key]
      response = HTTParty.get("https://cloud.iexapis.com/stable/stock/#{stock.symbol}/batch?types=quote&token=#{api_key}")
      if response.code == 200 && price = JSON.parse(response.body)["quote"]["lastestPrice"]
        self.user.balance -= price.to_i * diff
        self.user.save
      # idea for later test
      # else 
      #   raise ActiveRecord::Rollback 
      end
    end
  end

  class << self
  
    def find_or_create_by_symbol(user_id: nil, stock_symbol: nil)
      user_stock = 
        UserStock
          .joins('JOIN stocks ON user_stocks.stock_id = stocks.id')
          .where("user_id = ? AND stocks.symbol = ?", user_id, stock_symbol)
          .first
      user_stock ? user_stock : UserStock.create(user_id: user_id, stock_id: Stock.find_or_create_by(symbol: stock_symbol).id)
    end

  end

end