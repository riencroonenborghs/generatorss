module Uuid
  extend ActiveSupport::Concern

  included do
    before_validation :generate_uuid
    validates :uuid, presence: true
  end

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
