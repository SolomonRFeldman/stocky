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

end