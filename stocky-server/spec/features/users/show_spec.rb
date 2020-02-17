require 'rails_helper'

def create_token(user)
  JwtService.encode({user_id: user.id})
end

describe 'Users Features', :type => :feature do
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
    stub_request(:get, /MSFT/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 200, body: '{"quote":{"symbol":"MSFT","latestPrice":111,"previousClose":109}}', headers: {})
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
  end
  
  context 'when a user has many transactions and their show page is called without a token' do
    before do
      user_stock = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: "AAPL")
      user_stock.shares = 2
      user_stock.save
      user_stock = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: "FB")
      user_stock.shares = 3
      user_stock.save
      page.driver.submit :get, user_path(valid_user.id), {}
    end
    
    it 'returns 400' do
      expect(page.status_code).to eq(400)
    end
  end

  context 'when a user has many transactions and their show page is called with a valid token' do
    before do
      @user_stock_1 = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: "AAPL")
      @user_stock_1.shares = 2
      @user_stock_1.save
      @user_stock_2 = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: "FB")
      @user_stock_2.shares = 3
      @user_stock_2.save
      user = User.find_by(id: valid_user.id)
      @bad_stock = UserStock.find_or_new_by_symbol(user_id: valid_user.id, stock_symbol: "MSFT")
      @bad_stock.shares = 0
      @bad_stock.save
      user.balance = 5000
      user.save
      page.driver.header 'Token', create_token(valid_user)
      page.driver.submit :get, user_path(valid_user.id), {}
    end
    
    it 'returns 200' do
      expect(page.status_code).to eq(200)
    end

    it 'returns their id' do
      expect(JSON.parse(page.body)["id"]).to eq(valid_user.id)
    end

    it 'returns their balance' do
      expect(JSON.parse(page.body)["balance"]).to eq("5000.0")
    end

    it 'returns json with user_stocks key with an array of user_stocks with current price and day opening' do
      expect(JSON.parse(page.body)["user_stocks"]).to be_include({ 
        "id" => @user_stock_1.id,
        "shares" => 2,
        "symbol" => "AAPL",
        "latestPrice" => 100,
        "open" => 98
      })
      expect(JSON.parse(page.body)["user_stocks"]).to be_include({ 
        "id" => @user_stock_2.id,
        "shares" => 3,
        "symbol" => "FB",
        "latestPrice" => 125,
        "open" => 122
      })
    end

    it 'does not include user_stocks with no shares' do
      expect(JSON.parse(page.body)["user_stocks"]).to_not be_include({
        "id" => @bad_stock.id,
        "shares" => 0,
        "symbol" => "MSFT",
        "latestPrice" => 111,
        "open" => 109
      })
    end

    it 'returns json with user_stock_histories key with an array of user_stock_histories' do
      expect(JSON.parse(page.body)["user_stock_histories"]).to be_include({ 
        "id" => UserStockHistory.find_by(user_id: valid_user.id, stock_id: @user_stock_1.stock.id).id,
        "symbol" => "AAPL",
        "shares" => 2,
        "price" => "200.0"
      })
      expect(JSON.parse(page.body)["user_stock_histories"]).to be_include({ 
        "id" => UserStockHistory.find_by(user_id: valid_user.id, stock_id: @user_stock_2.stock.id).id,
        "symbol" => "FB",
        "shares" => 3,
        "price" => "375.0"
      })
    end
  end

end