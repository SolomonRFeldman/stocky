require 'rails_helper'

RSpec.describe UserStock, :type => :model do
  let(:valid_user) { create(:valid_user) }
  let(:valid_stock) { create(:valid_stock) }

  before(:each) do
    stub_request(:get, /AAPL/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 200, body: '{"quote":{"symbol":"APPL","lastestPrice":"100"}}', headers: {})
  end

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

  context "if the user_stock shares are added to" do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
      @user_stock.shares = 3
      @user_stock.save
    end

    it 'changes the shares' do
      expect(UserStock.find(@user_stock.id).shares).to eq(3)
    end

    it 'reduces the users balance based on price and quantity' do
      expect(User.find(valid_user.id).balance).to eq(4700)
    end
  end

  context "if the user_stock shares are reduced" do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 3)
      @user_stock.shares = 1
      @user_stock.save
    end

    it 'changes the shares' do
      expect(UserStock.find(@user_stock.id).shares).to eq(1)
    end

    it 'adds to the users balance based on price and quantity' do
      expect(User.find(valid_user.id).balance).to eq(5200)
    end
  end

end