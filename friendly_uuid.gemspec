Gem::Specification.new do |s|
  s.name = "friendly_uuid"
  s.version = `git tag --list --contains HEAD | head -n 1`.strip.sub("v", "")
  s.date = "2020-10-11"
  s.summary = "Make UUIDs pretty enough for use in URLs"
  s.description = <<-EOF
    FriendlyUUID is a Rails gem that shortens your UUID records' URLs.

    What once was 758d633c-61d4-4dfc-ba52-b7b498971097 becomes 758d.

    FriendlyUUID does not introduce any new state to your models, even under the hood.

    FriendlyUUID URLs are exactly as unique as they need to be. The first record will be one character. Would-be collisions expand to two characters, and so on.

    FriendlyUUID is inspired by friendly_id, but is focused on being lightweight and specific to models with UUID primary keys.
  EOF
  s.authors = ["Ben Carlsson"]
  s.email = "ben@twos.dev"
  s.files = ["lib/friendly_uuid.rb"]
  s.homepage = "https://github.com/glacials/friendly_uuid"
  s.licenses = ["CC-BY-NC-SA-4.0", "LicenseRef-Licenseland"]
end
