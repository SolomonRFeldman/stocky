require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:valid_user) { create(:valid_user) }
  let(:valid_stock) { create(:valid_stock) }
  
  it "is valid with a name, email, and password" do
    expect(valid_user).to be_valid
  end

  it "encryptes the password" do
    expect(valid_user.password_digest).to_not eq('123')
  end

  it "is invalid with a null email" do
    expect(build(:valid_user, email: nil)).to_not be_valid
  end

  it "is invalid with a null name" do
    expect(build(:valid_user, name: nil)).to_not be_valid
  end

  it "is invalid with a null password" do
    expect(build(:valid_user, password: nil)).to_not be_valid
  end

  it "is invalid with a blank email" do
    expect(build(:valid_user, email: "")).to_not be_valid
  end

  it "is invalid with a blank name" do
    expect(build(:valid_user, name: "")).to_not be_valid
  end

  it "is invalid with a blank password" do
    expect(build(:valid_user, password: "")).to_not be_valid
  end

  it "is invalid with a mismatched password" do
    expect(build(:valid_user, password_confirmation: "321")).to_not be_valid
  end

  context "when another user has taken an email" do
    before do
      valid_user
    end
    
    it "is invalid with the same email as the other user" do
      expect(build(:jelly_user, email: "Test@123.com")).to_not be_valid
    end

    it "is invalid with the same email as the other user in a different case" do
      expect(build(:jelly_user, email: "test@123.com")).to_not be_valid
    end
  end

  context "when login_hash is called on a user" do
    before do
      @hash = valid_user.login_hash
    end

    it "returns its id, name, and token" do
      expect(@hash["id"]).to eq(valid_user.id)
      expect(@hash["name"]).to eq(valid_user.name)
      expect(@hash["token"]).to be_instance_of(String)
    end

    it "does not return email and password" do
      expect(@hash["email"]).to be_nil
      expect(@hash["password"]).to be_nil
      expect(@hash["password_digest"]).to be_nil
    end
  end

  context "when authenticate is called on the class with a valid email and password" do
    before do
      valid_user
      @user = User.authenticate({ email: "Test@123.com", password: "123" })
    end

    it "returns the user" do
      expect(@user).to eq(valid_user)
    end
  end

  context "when authenticate is called on the class with a valid email but invalid password" do
    before do
      valid_user
      @user = User.authenticate({ email: "Test@123.com", password: "321" })
    end

    it "returns nil" do
      expect(@user).to eq(nil)
    end
  end

  context "when authenticate is called on the class with a invalid email" do
    before do
      valid_user
      @user = User.authenticate({ email: "est@123.com", password: "123" })
    end

    it "returns nil" do
      expect(@user).to eq(nil)
    end
  end

  it 'defaults balance to 5000' do
    expect(valid_user.balance).to eq(5000)
  end

  context 'when a user has a negative balance' do
    before do
      @user = valid_user
      @user.balance = -1
    end

    it 'is not valid' do
      expect(@user).to_not be_valid
    end
  end

  context 'when a user is joined to stocks' do
    before do
      @user_stock_1 = UserStock.create(user_id: valid_user.id, stock_id: valid_stock.id)
      @stock_2 = build(:valid_stock, symbol: 'FB')
      @stock_2.save
      @user_stock_2 = UserStock.create(user_id: valid_user.id, stock_id: @stock_2.id)
    end

    it 'has many user_stocks' do
      expect(valid_user.user_stocks).to be_include(@user_stock_1)
      expect(valid_user.user_stocks).to be_include(@user_stock_2)
    end

    it 'has many stocks' do
      expect(valid_user.stocks).to be_include(valid_stock)
      expect(valid_user.stocks).to be_include(@stock_2)
    end
  end

  context 'when a user is joined to user stock histories' do
    before do
      @user_stock_history_1 = UserStockHistory.create(user_id: valid_user.id, stock_id: valid_stock.id, price: 200, shares: 2)
      @stock_2 = build(:valid_stock, symbol: 'FB')
      @stock_2.save
      @user_stock_history_2 = UserStockHistory.create(user_id: valid_user.id, stock_id: @stock_2.id, price: 300, shares: 3)
    end

    it 'has many user_stocks' do
      expect(valid_user.user_stock_histories).to be_include(@user_stock_history_1)
      expect(valid_user.user_stock_histories).to be_include(@user_stock_history_2)
    end
  end
      
end