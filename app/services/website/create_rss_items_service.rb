class Website::CreateRssItemsService < CreateRssItemsService
  def initialize(website:)
    super(subscriptable: website)
  end
end
