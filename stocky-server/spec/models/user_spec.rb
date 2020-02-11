require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:valid_user) { create(:valid_user) }
  
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

end