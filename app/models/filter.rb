class Filter < ApplicationRecord
  VALID_COMPARISONS = %w[eq ne].freeze
  COMPARISONS = { "Contains": "eq", "Does not contain": "ne" }.freeze

  belongs_to :user

  validates :value, presence: true
  validates :comparison, inclusion: { in: VALID_COMPARISONS }

  def chain(scope)
    value.upcase.split(",").map do |part|
      scope = scope.where("upper(rss_items.title) #{sql_comparison} ?", "%#{part}%")
    end

    scope
  end

  def human_readable
    "#{human_readable_comparison} #{value.upcase}"
  end

  private

  def sql_comparison
    @sql_comparison ||= comparison == "ne" ? "not like" : "like"
  end

  def human_readable_comparison
    COMPARISONS.invert[comparison].downcase
  end
end
