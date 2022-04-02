class LoadUrlDataService
  include AppService

  attr_reader :url, :data

  def initialize(url:)
    @url = url
  end

  def call
    valid_url?
    return unless success?

    @data = HTTParty.get(url, verify: false, headers: headers)&.body
  rescue StandardError => e
    errors.add(:base, e.message)
    Rails.logger.error "#{self.class} :: #{e.message}"
  end

  private

  def valid_url?
    errors.add(:base, "not a valid URL") unless url =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end

  def headers
    { "User-Agent" => "GeneratoRSS/1.0" }
  end
end
