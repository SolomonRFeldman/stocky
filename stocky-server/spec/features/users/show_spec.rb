require 'rails_helper'

def create_token(user)
  JwtService.encode({user_id: user.id})
end

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
      .to_return(status: 200, body: '{"quote":{"symbol":"APPL","lastestPrice":"100"}}', headers: {})
    stub_request(:get, /FB/)
    .with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }
    )
    .to_return(status: 200, body: '{"quote":{"symbol":"FB","lastestPrice":"125"}}', headers: {})
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

end