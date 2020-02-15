require 'rails_helper'

RSpec.describe UserStock, :type => :model do
  let(:valid_user) { create(:valid_user) }
  let(:valid_stock) { create(:valid_stock) }

  context 'when it is created with a user and a stock' do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
    end

    it 'is valid' do
      expect(@user_stock).to be_valid
    end

    it 'defaults shares to 0' do
      expect(@user_stock.shares).to eq(0)
    end

    it 'has a user' do
      expect(@user_stock.user).to eq(valid_user)
    end

    it 'has a stock' do
      expect(@user_stock.stock).to eq(valid_stock)
    end
  end

  context "when a user doesn't have a stock and UserStock.find_or_create_by_symbol is called" do
    before do
      valid_stock
    end

    it 'creates the user_stock' do
      expect(UserStock.find_or_create_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')).to be_valid
      expect(UserStock.find_or_create_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')).to be_instance_of(UserStock)
    end
  end

  context "when a user has a stock and UserStock.find_or_create_by_symbol is called" do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
    end

    it 'returns the user_stock' do
      expect(UserStock.find_or_create_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL').id).to eq(@user_stock.id)
    end
  end


  context "if the stock does not exist and UserStock.find_or_create_by_symbol is called" do
    before do
      @user_stock = UserStock.find_or_create_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')
    end

    it 'creates the stock' do
      expect(Stock.all.last).to_not be_nil
      expect(Stock.all.last.symbol).to eq('AAPL')
    end

    it 'creates the user_stock' do
      expect(@user_stock).to be_valid
      expect(@user_stock).to be_instance_of(UserStock)
    end
  end

end