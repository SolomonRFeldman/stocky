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

  context 'when it is created' do
    before do
      @user_stock_history = UserStockHistory.create(user_id: valid_user.id, stock_id: valid_stock.id, price: 200, shares: 2)
    end

    it 'has a user' do
      expect(@user_stock_history.user).to eq(valid_user)
    end

    it 'has a stock' do
      expect(@user_stock_history.stock).to eq(valid_stock)
    end
  end

  context "when UserStockHistory.with_symbol is called with a collection" do
    before do
      @user_stock_history_1 = UserStockHistory.create(
        user_id: valid_user.id, stock_id: valid_stock.id, shares: 3, price: 300
      )
      @user_stock_history_2 = UserStockHistory.create(
        user_id: valid_user.id, stock_id: create(:valid_stock, symbol: "FB").id, shares: 2, price: 250
      )
      @user_stock_histories = UserStockHistory.with_symbol(UserStockHistory.all)
    end

    it "returns the user_stock with an id, symbol, shares, and price" do
      user_stock_history = @user_stock_histories.detect{ |user_stock_hist| user_stock_hist["id"] == @user_stock_history_2.id }
      expect(user_stock_history["id"]).to eq(@user_stock_history_2.id)
      expect(user_stock_history["shares"]).to eq(2)
      expect(user_stock_history["symbol"]).to eq("FB")
      expect(user_stock_history["price"]).to eq(250)
    end
  end

  context "when .with_symbol is called on an instance of user_stock_history" do
    before do
      @user_stock_history = UserStockHistory.create(
        user_id: valid_user.id, stock_id: valid_stock.id, shares: 3, price: 300
      )
      @user_stock_history_sym = @user_stock_history.with_symbol
    end

    it "returns the user_stock with an id, symbol, shares, and price" do
      expect(@user_stock_history_sym["id"]).to eq(@user_stock_history.id)
      expect(@user_stock_history_sym["shares"]).to eq(3)
      expect(@user_stock_history_sym["symbol"]).to eq("AAPL")
      expect(@user_stock_history_sym["price"]).to eq(300)
    end
  end

end