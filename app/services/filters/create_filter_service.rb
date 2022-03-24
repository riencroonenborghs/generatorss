class Filters::CreateFilterService
  include AppService

  attr_reader :filter

  def initialize(user:, comparison:, value:)
    @user = user
    @comparison = comparison
    @value = value.upcase
  end

  def call
    Filter.transaction do
      filter_exists?
      return unless success?

      @filter = user.filters.build(comparison: comparison, value: value)
      errors.merge!(filter.errors) unless filter.save
    end
  end

  private

  attr_reader :user, :comparison, :value

  def filter_exists?
    errors.add(:base, "filter already exists") if user.filters.exists?(comparison: comparison, value: value)
  end
end
