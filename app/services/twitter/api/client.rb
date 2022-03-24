class Twitter::Api::Client
  include AppService
  include HTTParty

  base_uri "https://api.twitter.com/2"
  headers "Authorization": "Bearer #{ENV['TWITTER_BEARER_TOKEN']}"

  def get(url, query: {})
    self.class.get(url, query: query)
  end

  def parse(response)
    json = JSON.parse(response.body)

    if response.success?
      parse_success(json)
    else
      parse_failure(json)
    end
  rescue StandardError => e
    self.errors.add(:base, e.message) # rubocop:disable Style/RedundantSelf
  end

  private

  def parse_success(json)
    return json["data"] if json.key?("data")
    return nil if json.key?("meta") && json.dig("meta", "result_count").zero?

    errors = json["errors"].map { |error| error["message"] || error["detail"] }.join(", ")
    self.errors.add(:base, errors)
  end

  def parse_failure(json)
    error = json["detail"]
    self.errors.add(:base, error) # rubocop:disable Style/RedundantSelf
  end
end
