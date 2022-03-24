class Discord::Api::Channel < Struct.new(:id, :guild_id, :name, :topic, keyword_init: true)
  def self.build_from(json)
    message = new(
      id: json["id"],
      guild_id: json["guild_id"],
      name: json["name"],
      topic: json["topic"]
    )
  end
end
