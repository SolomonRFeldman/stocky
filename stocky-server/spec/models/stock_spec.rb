require 'rails_helper'

RSpec.describe Stock, :type => :model do
  let(:valid_stock) { create(:valid_stock) }

  it('is valid with a symbol') do
    expect(valid_stock).to be_valid
  end

  it "is invalid with a blank symbol" do
    expect(build(:valid_stock, symbol: '')).to_not be_valid
  end

  it "is invalid with a nil symbol" do
    expect(build(:valid_stock, symbol: nil)).to_not be_valid
  end

end