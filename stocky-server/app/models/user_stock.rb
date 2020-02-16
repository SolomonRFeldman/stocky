class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  before_validation do
    price = 0
    self.id ? diff = self.shares - UserStock.find(self.id).shares : diff = self.shares
    if diff != 0
      api_key = Rails.application.credentials[Rails.env.to_sym][:iex_key]
      response = HTTParty.get("https://cloud.iexapis.com/stable/stock/#{stock.symbol}/batch?types=quote&token=#{api_key}")
      if response.code == 200 && price = JSON.parse(response.body)["quote"]["lastestPrice"]
        self.user = User.find(self.user.id)
        self.user.balance -= price.to_i * diff
        user_stock_history = UserStockHistory.new(
          user_id: self.user.id, stock_id: self.stock.id, price: price.to_i * diff, shares: diff
        )
        self.user.user_stock_histories << user_stock_history
        self.errors.messages[:user] = self.user.errors.messages unless self.user.valid?
      else 
        self.errors.add(:stock, 'api request failed')
      end
    end
  end

  before_save do
    self.user.save
  end

  class << self
  
    def find_or_new_by_symbol(user_id: nil, stock_symbol: nil)
      user_stock = 
        UserStock
          .joins('JOIN stocks ON user_stocks.stock_id = stocks.id')
          .where("user_id = ? AND stocks.symbol = ?", user_id, stock_symbol)
          .first
      user_stock ? user_stock : UserStock.new(user_id: user_id, stock: Stock.find_or_create_by(symbol: stock_symbol))
    end

  end

end