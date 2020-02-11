class JwtService
  def self.encode(payload)
    JWT.encode(payload, Rails.application.credentials[:secret_key_base], 'HS256')
  end
end