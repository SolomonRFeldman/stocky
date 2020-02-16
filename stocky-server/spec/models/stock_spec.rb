require 'rails_helper'

RSpec.describe Stock, :type => :model do
  let(:valid_stock) { create(:valid_stock) }
  let(:valid_user) { create(:valid_user) }
  let(:jelly_user) { create(:jelly_user) }

  it('is valid with a symbol') do
    expect(valid_stock).to be_valid
  end

  it "is invalid with a blank symbol" do
    expect(build(:valid_stock, symbol: '')).to_not be_valid
  end

  it "is invalid with a nil symbol" do
    expect(build(:valid_stock, symbol: nil)).to_not be_valid
  end

  context 'when a user is joined to stocks' do
    before do
      @user_stock_1 = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
      @user_stock_2 = UserStock.create(user_id: jelly_user.id, stock_id: valid_stock.id)
    end

    it 'has many user_stocks' do
      expect(valid_stock.user_stocks).to be_include(@user_stock_1)
      expect(valid_stock.user_stocks).to be_include(@user_stock_2)
    end

    it 'has many users' do
      expect(valid_stock.users).to be_include(valid_user)
      expect(valid_stock.users).to be_include(jelly_user)
    end
  end

  context 'when a stock is joined to user stock histories' do
    before do
      @user_stock_history_1 = UserStockHistory.create(user_id: valid_user.id, stock_id: valid_stock.id, price: 200, shares: 2)
      @user_stock_history_2 = UserStockHistory.create(user_id: jelly_user.id, stock_id: valid_stock.id, price: 300, shares: 3)
    end

    it 'has many user_stock_histories' do
      expect(valid_stock.user_stock_histories).to be_include(@user_stock_history_1)
      expect(valid_stock.user_stock_histories).to be_include(@user_stock_history_2)
    end
  end

end