class Rss::Channel < Struct.new(:title, :link, :last_build_date, :ttl, :items, keyword_init: true) # rubocop:disable Style/StructInheritance
end
