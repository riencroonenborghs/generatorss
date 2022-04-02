Discord::Api::Channel = Struct.new(:id, :guild_id, :name, :topic, keyword_init: true) do
  def self.build_from(json)
    new(
      id: json["id"],
      guild_id: json["guild_id"],
      name: json["name"],
      topic: json["topic"]
    )
  end
end
