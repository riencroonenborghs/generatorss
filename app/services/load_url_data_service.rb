class LoadUrlDataService
  include AppService

  attr_reader :url, :data

  def initialize(url:)
    @url = url
  end

  def call
    valid_url?
    return unless success?

    @data = HTTParty.get(url, verify: false)&.body
  end

  private

  def valid_url?
    errors.add(:base, "not a valid URL") unless url =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end
end
