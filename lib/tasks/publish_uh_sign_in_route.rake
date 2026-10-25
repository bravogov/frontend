# Publishes the native Content Store route for the existing Frontend sign-in
# service chooser at /sign-in. It is not a new account, identity provider,
# government service, or replacement for an application's own sign-in.
#
# Run through the authorised release process after verifying that /sign-in
# has no existing, separately owned draft/live Publishing API record.
require "gds_api/publishing_api/special_route_publisher"

namespace :publishing_api do
  desc "Register the existing GOV.UH sign-in service chooser in Publishing API"
  task publish_uh_sign_in_route: :environment do
    publisher = GdsApi::PublishingApi::SpecialRoutePublisher.new(
      publishing_api: Services.publishing_api,
    )

    publisher.publish(
      content_id: "e7ae2b4d-a1f5-4512-9c7b-5a5dd8e56afb",
      base_path: "/sign-in",
      document_type: "special_route",
      locale: "en",
      title: "Sign in to GOV.UH services",
      description: "Find the government account or online service you need to sign in to.",
      publishing_app: "frontend",
      rendering_app: "frontend",
      type: "exact",
      update_type: "major",
    )
  end
end
