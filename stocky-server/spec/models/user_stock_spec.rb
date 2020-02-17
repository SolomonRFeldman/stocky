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
      .to_return(status: 200, body: '{"quote":{"symbol":"APPL","latestPrice":100,"previousClose":98}}', headers: {})
    stub_request(:get, /FB/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 200, body: '{"quote":{"symbol":"FB","latestPrice":125,"previousClose":122}}', headers: {})
    combined_response = {
      "AAPL" => {
        "quote" => {
          "symbol" => "AAPL",
          "latestPrice" => 100,
          "previousClose" => 98
        }
      },
      "FB" => {
        "quote" => {
          "symbol" => "FB",
          "latestPrice" => 125,
          "previousClose" => 122
        }
      }
    }.to_json
    stub_request(:get, /FB,AAPL|AAPL,FB/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 200, body: combined_response, headers: {})
    stub_request(:get, /notARealSymbol/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 404, body: 'Unknown symbol', headers: {})
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

    it 'does not create a UserStockHistory' do
      expect(UserStockHistory.all.last).to be_nil
    end

    it 'has a user' do
      expect(@user_stock.user).to eq(valid_user)
    end

    it 'has a stock' do
      expect(@user_stock.stock).to eq(valid_stock)
    end
  end

  context 'when it is created with a user and without a stock' do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id)
    end

    it 'is not valid' do
      expect(@user_stock).to_not be_valid
    end
  end

  context 'when it is created without a user and with a stock' do
    before do
      @user_stock = UserStock.create(stock_id: valid_stock.id)
    end

    it 'is not valid' do
      expect(@user_stock).to_not be_valid
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

      it 'creates a user stock history' do
        expect(UserStockHistory.all.last).to be_instance_of(UserStockHistory)
        expect(UserStockHistory.all.last.shares).to eq(2)
        expect(UserStockHistory.all.last.price).to eq(200)
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

      it 'creates a user stock history' do
        expect(UserStockHistory.all.last).to be_instance_of(UserStockHistory)
        expect(UserStockHistory.all.last.shares).to eq(-2)
        expect(UserStockHistory.all.last.price).to eq(-200)
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

  context "when a user_stock is created with shares" do
    context "when it is created successfully" do
      before do
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 2)
      end

      it 'creates the user_stock' do
        expect(UserStock.find_by(id: @user_stock.id)).to_not be_nil
      end

      it 'reduces the users balance based on price and quantity' do
        expect(User.find(valid_user.id).balance).to eq(4800)
      end

      it 'creates a user stock history' do
        expect(UserStockHistory.all.last).to be_instance_of(UserStockHistory)
        expect(UserStockHistory.all.last.shares).to eq(2)
        expect(UserStockHistory.all.last.price).to eq(200)
      end

      it 'stores the created history in .last_history' do
        expect(@user_stock.last_history).to be_instance_of(UserStockHistory)
        expect(@user_stock.last_history.shares).to eq(2)
        expect(@user_stock.last_history.price).to eq(200)
      end
    end

    context "when it fails to recieve a 200 request to the api" do
      before do
        stub_request(:get, /AAPL/)
        .with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ruby'
          }
        )
        .to_return(status: 400, body: '', headers: {})
        @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 2)
      end

      it "is not valid" do
        expect(@user_stock).to_not be_valid
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
        @user = create(:valid_user, balance: 100)
        @user_stock = UserStock.create(user_id: @user.id, stock_id: valid_stock.id, shares: 2)
      end

      it 'is not valid' do
        expect(@user_stock).to_not be_valid
      end

      it "keeps the users balance the same" do
        expect(User.find(@user.id).balance).to eq(100)
      end

      it "adds an error to the user_stocks user with the validation failure message" do
        expect(@user_stock.errors.messages[:user][:balance]).to be_include('must be greater than or equal to 0')
      end
    end
  end

  context "when UserStock.with_prices is called with a collection of user_stocks" do
    before do
      @user_stock_1 = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 3)
      @user_stock_2 = UserStock.create(user_id: valid_user.id, stock_id: create(:valid_stock, symbol: "FB").id, shares: 2)
      @user_stocks = UserStock.with_prices(UserStock.all)
    end

    it "returns the user_stock with an id, shares, symbol, latestPrice, and open" do
      user_stock = @user_stocks.detect{ |user_stock| user_stock["id"] == @user_stock_2.id }
      expect(user_stock["id"]).to eq(@user_stock_2.id)
      expect(user_stock["shares"]).to eq(2)
      expect(user_stock["symbol"]).to eq("FB")
      expect(user_stock["latestPrice"]).to eq(125)
      expect(user_stock["open"]).to eq(122)
    end
  end

  context "when UserStock.with_prices is called with an empty collection" do
    before do
      @user_stocks = UserStock.with_prices(UserStock.where(user_id: 0))
    end

    it "returns an empty array" do
      expect(@user_stocks).to eq([])
    end
  end

  context "when user_stock.with_prices is called with on an instance of user_stock" do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: 3)
      @user_stock_prices = @user_stock.with_prices
    end

    it "returns the user_stock with an id, shares, symbol, latestPrice, and open" do
      expect(@user_stock_prices["id"]).to eq(@user_stock.id)
      expect(@user_stock_prices["shares"]).to eq(3)
      expect(@user_stock_prices["symbol"]).to eq("AAPL")
      expect(@user_stock_prices["latestPrice"]).to eq(100)
      expect(@user_stock_prices["open"]).to eq(98)
    end
  end

  context "when a user stock is created with an invalid stock symbol" do
    before do
      @bad_stock = create(:valid_stock, symbol: 'notARealSymbol')
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: @bad_stock.id, shares: 3)
    end

    it "is not valid" do
      expect(@user_stock).to_not be_valid
    end

    it 'adds a bad symbol error message' do
      expect(@user_stock.errors.messages[:stock]).to be_include('unknown symbol')
    end
  end

  context 'when it is created with negative shares' do
    before do
      @user_stock = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id, shares: -1)
    end

    it 'is not valid' do
      expect(@user_stock).to_not be_valid
    end
  end

end