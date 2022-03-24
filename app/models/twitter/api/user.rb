class Twitter::Api::User < Struct.new(:profile_image_url, :id, :description, :url, :username, :name, :verified, keyword_init: true) # rubocop:disable Style/StructInheritance
end
