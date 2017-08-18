class UserInterestsSerializer
  include Rails.application.routes.url_helpers

  def initialize(resource)
    @resource = resource
  end

  def serialize
    { interests: { links: links, data: resources_data } }
  end

  private

  def links
    { self: link, related: link }
  end

  def resources_data
    @resource.interests.map { |interest| InterestSerializer.new(interest).serialize }
  end

  def link
    api_user_interests_url(user_id: @resource.id, host: Rails.application.secrets.app_host)
  end
end
