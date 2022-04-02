Discord::Api::MessageEmbed = Struct.new(:type, :url, :title, keyword_init: true) do
  def self.build_from(json)
    new(
      type: json["type"],
      url: json["url"],
      title: json["title"]
    )
  end

  def link?
    type == "link"
  end
end
