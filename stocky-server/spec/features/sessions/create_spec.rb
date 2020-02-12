require 'rails_helper'

describe 'Sessions Features', :type => :feature do
  let(:valid_user) { create(:valid_user) }

  let(:login_hash) do
    {
      email: "Test@123.com",
      password: "123"
    }
  end

  context "when a valid email and password are provided" do
    before do
      valid_user
      page.driver.submit :post, login_path, user: login_hash
    end
    
    it "returns status 200" do
      expect(page.status_code).to eq(200)
    end

    it "returns the users id, name, and an encrypted token, jsonified" do
      expect(page).to have_content({id: User.find_by(name: "Test").id}.to_json.tr('{}', ''))
      expect(page).to have_content({name: "Test"}.to_json.tr('{}', ''))
      expect(page).to have_content(/"token":"([^"]*)"/)
      expect(page).to_not have_content({email: "Test@123.com"}.to_json.tr('{}', ''))
      expect(page).to_not have_content({password: "123"}.to_json.tr('{}', ''))
    end
  end

  context "when an invalid password is provided" do
    before do
      valid_user
      page.driver.submit :post, login_path, user: login_hash.merge(password: "321")
    end
    
    it "returns status 400" do
      expect(page.status_code).to eq(400)
    end
  end

  context "when an invalid email is provided" do
    before do
      valid_user
      page.driver.submit :post, login_path, user: login_hash.merge(email: "notarealemail@nope.com")
    end
    
    it "returns status 400" do
      expect(page.status_code).to eq(400)
    end
  end

  context "when a token is in the header" do
    before do
      valid_user
      page.driver.options[:headers] = {}
      page.driver.header 'Token', JwtService.encode({ user_id: valid_user.id })
      page.driver.submit :post, login_path, nil
    end
    
    it "returns status 200" do
      expect(page.status_code).to eq(200)
    end

    it "returns the users id, name, and an encrypted token, jsonified" do
      expect(page).to have_content({id: User.find_by(name: "Test").id}.to_json.tr('{}', ''))
      expect(page).to have_content({name: "Test"}.to_json.tr('{}', ''))
      expect(page).to have_content(/"token":"([^"]*)"/)
      expect(page).to_not have_content({email: "Test@123.com"}.to_json.tr('{}', ''))
      expect(page).to_not have_content({password: "123"}.to_json.tr('{}', ''))
    end
  end

  context "when an invalid token is in the header" do
    before do
      valid_user
      page.driver.header 'Token', "wrong numba"
      page.driver.submit :post, login_path, nil
    end
    
    it "returns status 400" do
      expect(page.status_code).to eq(400)
    end

  end

end