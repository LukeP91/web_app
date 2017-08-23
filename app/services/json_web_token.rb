class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.jwt_secret_key)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.jwt_secret_key)[0])
  rescue
    nil
  end
end
