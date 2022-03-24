class Twitter::Api::Tweet < Struct.new(:id, :title, :text, :created_at, keyword_init: true) # rubocop:disable Style/StructInheritance
end
