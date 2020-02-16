require 'rails_helper'

describe 'Users Features', :type => :feature do
  let(:valid_user) { create(:valid_user) }

  before(:each) do
    stub_request(:get, /AAPL/)
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      )
      .to_return(status: 200, body: '{"quote":{"symbol":"APPL","latestPrice":100,"open":98}}', headers: {})
    stub_request(:get, /FB/)
    .with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }
    )
    .to_return(status: 200, body: '{"quote":{"symbol":"FB","lastestPrice":125}}', headers: {})
  end

  context 'when a user posts to user_stocks without a token' do
    before do
      page.driver.submit :post, user_user_stocks_path(user_id: valid_user.id), { symbol: "AAPL", shares: 2 }
    end
    
    it 'returns 400' do
      expect(page.status_code).to eq(400)
    end
  end

  context 'when a user posts to user_stocks with the wrong token' do
    before do
      page.driver.header 'Token', JwtService.encode({ user_id: valid_user.id + 100 })
      page.driver.submit :post, user_user_stocks_path(user_id: valid_user.id), { symbol: "AAPL", shares: 2 }
    end
    
    it 'returns 400' do
      expect(page.status_code).to eq(400)
    end
  end

  context 'when a user posts to user_stocks with the right token' do
    before do
      page.driver.header 'Token', JwtService.encode({ user_id: valid_user.id })
      page.driver.submit :post, user_user_stocks_path(user_id: valid_user.id), { user_stock: { symbol: "AAPL", shares: 2 } }
    end
    
    it 'returns 200' do
      expect(page.status_code).to eq(200)
    end

    it 'returns json with user_stock that was created with current price, day opening, and the users new balance' do
      resp = JSON.parse(page.body)
      expect(resp["id"]).to eq(UserStock.all.last.id)
      expect(resp["shares"]).to eq(2)
      expect(resp["symbol"]).to eq("AAPL")
      expect(resp["latestPrice"]).to eq(100)
      expect(resp["open"]).to eq(98)
      expect(resp["new_balance"]).to eq("4800.0")
    end

    it 'returns json with the user_stock_history in the user_stock_history key' do
      expect(JSON.parse(page.body)["user_stock_history"]).to eq({ 
        "id" => UserStockHistory.find_by(user_id: valid_user.id, stock_id: UserStock.all.last.stock_id).id,
        "symbol" => "AAPL",
        "shares" => 2,
        "price" => "200.0"
      })
    end
  end

end