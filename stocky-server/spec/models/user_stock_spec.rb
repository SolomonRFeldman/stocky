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

  context "when a user doesn't have a stock and UserStock.find_or_new_by_symbol is called" do
    before do
      valid_stock
    end

    it 'initializes the user_stock' do
      expect(UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')).to be_valid
      expect(UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')).to be_instance_of(UserStock)
    end
  end

  context "when a user has a stock and UserStock.find_or_new_by_symbol is called" do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
    end

    it 'returns the user_stock' do
      expect(UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL').id).to eq(@user_stock.id)
    end
  end


  context "if the stock does not exist and UserStock.find_or_new_by_symbol is called and saved" do
    before do
      @user_stock = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: 'AAPL')
      @user_stock.save
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

  context "when a user_stock is updated" do
    context "if the user_stock shares are increased" do
      before do
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 1)
        user = @user_stock.user
        user.balance = 5000
        user.save
        @user_stock.shares = 3
        @user_stock.save
      end

      it 'changes the shares' do
        expect(UserStock.find(@user_stock.id).shares).to eq(3)
      end

      it 'reduces the users balance based on price and quantity' do
        expect(User.find(valid_user.id).balance).to eq(4800)
      end
    end

    context "if the user_stock shares are reduced" do
      before do
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 3)
        user = @user_stock.user
        user.balance = 5000
        user.save
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

    context "if it fails to recieve a 200 request to the api" do
      before do
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 1)
        stub_request(:get, /AAPL/)
        .with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ruby'
          }
        )
        .to_return(status: 400, body: '', headers: {})
        user = @user_stock.user
        user.balance = 5000
        user.save
        @user_stock.shares = 3
        @user_stock.save
      end

      it "doesn't change the shares" do
        expect(UserStock.find(@user_stock.id).shares).to eq(1)
      end

      it "doesn't change the user's balance" do
        expect(User.find(valid_user.id).balance).to eq(5000)
      end

      it "adds an error to the user_stocks stock with the message 'api request failed'" do
        expect(@user_stock.errors.messages[:stock]).to be_include('api request failed')
      end
    end

    context "if the user_stock exists and shares are increased so that the user balance becomes negative" do
      before do
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 1)
        user = @user_stock.user
        user.balance = 100
        user.save
        @user_stock.shares = 3
        @user_stock.save
      end

      it "doesn't change the shares" do
        expect(UserStock.find(@user_stock.id).shares).to eq(1)
      end

      it "keeps the users balance the same" do
        expect(User.find(valid_user.id).balance).to eq(100)
      end

      it "adds an error to the user_stocks user with the validation failure message" do
        expect(@user_stock.errors.messages[:user][:balance]).to be_include('must be greater than or equal to 0')
      end
    end
  end

end