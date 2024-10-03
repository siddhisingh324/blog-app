class JsonWebToken
  SECRET = Rails.application.credentials.secret_key_base
  def self.encode(payload)
    payload[:exp] = payload[:exp].to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature
    "token expired"
  rescue
    nil
  end
end
