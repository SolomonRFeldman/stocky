require 'rails_helper'

RSpec.describe JwtService, :type => :service do
  
  it "encodes a hash into a string that does not include the information" do
    expect(JwtService.encode({ user_id: 1 })).to_not eq({ user_id: 1 })
    expect(JwtService.encode({ user_id: 1 })).to be_instance_of(String)
    expect(JwtService.encode({ user_id: 1 })).to_not be_include("user_id: 1")
  end

  context "when a hash is encoded" do
    before do
      @token = JwtService.encode({ user_id: 1 })
    end

    it "decodes the encoded string into its original form with a stringified key" do
      expect(JwtService.decode(@token)).to eq({"user_id" => 1 })
    end
  end

end