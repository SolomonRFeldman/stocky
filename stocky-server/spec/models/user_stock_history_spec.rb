require 'rails_helper'

RSpec.describe UserStockHistory, :type => :model do
  let(:valid_user) { create(:valid_user) }
  let(:valid_stock) { create(:valid_stock) }

  it 'is valid with a user, stock, price, and amount' do
    UserStockHistory.create(user_id: valid_user.id, stock_id: valid_stock.id, price: 200, shares: 2)
  end

  it 'is valid with a user and stock and a negative price and amount' do
    UserStockHistory.create(user_id: valid_user.id, stock_id: valid_stock.id, price: -200, shares: -2)
  end

end