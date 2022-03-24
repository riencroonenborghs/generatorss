class Discord::Api::Client
  include AppService
  include HTTParty

  base_uri "https://discord.com/api/v8"
  headers "Authorization" => ENV['DISCORD_AUTHORIZATION']

  def get(url)
    response = self.class.get(url)
    body = JSON.parse(response.body)
    return body if response.success?

    self.errors.add(:base, body["message"])
  rescue StandardError => e
    self.errors.add(:base, e.message)
  end
end