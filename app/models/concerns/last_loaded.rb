module LastLoaded
  extend ActiveSupport::Concern

  def should_load_tweets?
    last_loaded.nil? ||
      last_loaded < 15.minutes.ago
  end
end
