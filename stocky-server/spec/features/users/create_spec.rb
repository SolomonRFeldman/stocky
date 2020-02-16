require 'rails_helper'

describe 'Users Features', :type => :feature do
  let(:valid_user) { create(:valid_user) }

  let(:user_hash) do
    {
      name: "Test",
      email: "Test@123.com",
      password: "123",
      password_confirmation: "123"
    }
  end

  context "when valid user data is posted to signup" do
    before do
      page.driver.submit :post, signup_path, user: user_hash
    end

    it "returns status 200" do
      expect(page.status_code).to eq(200)
    end

    it "creates the user" do
      expect(User.find_by(name: "Test")).to_not be_nil
    end

    it "returns the users id, name, balance, and an encrypted token, jsonified" do
      expect(page).to have_content({id: User.find_by(name: "Test").id}.to_json.tr('{}', ''))
      expect(page).to have_content({name: "Test"}.to_json.tr('{}', ''))
      expect(page).to have_content(/"token":"([^"]*)"/)
      expect(page).to have_content({balance: "5000.0"}.to_json.tr('{}', ''))
      expect(page).to_not have_content({email: "Test@123.com"}.to_json.tr('{}', ''))
      expect(page).to_not have_content({password: "123"}.to_json.tr('{}', ''))
    end
  end

  context "when invalid user data is posted to signup" do
    before do
      valid_user
      @invalid_hash = user_hash.merge(password_confirmation: "321")
      page.driver.submit :post, signup_path, user: user_hash.merge(password_confirmation: "321")
    end

    it "returns status 400" do
      expect(page.status_code).to eq(400)
    end

    it "returns the errors" do
      expect(page).to have_content({ errors: User.create(@invalid_hash).errors }.to_json)
    end
  end

end