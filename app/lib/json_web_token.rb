class JsonWebToken
  SECRET = Rails.application.secret_key_base

  def self.encode(exp: 24.hours.from_now, **payload)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET, true, { algorithm: "HS256" })
    decoded[0].with_indifferent_access
  end
end

