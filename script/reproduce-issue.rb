#!/usr/bin/env ruby
begin
  $LOAD_PATH << "#{Dir.pwd}/lib"
  require 'pact_broker/test/http_test_data_builder'
  base_url = ENV['PACT_BROKER_BASE_URL'] || 'http://localhost:9292'

  td = PactBroker::Test::HttpTestDataBuilder.new(base_url)
  td.delete_integration(consumer: "foo-consumer", provider: "bar-provider")
    .publish_pact(consumer: "foo-consumer", consumer_version: "1", provider: "bar-provider", content_id: "111", tag: "production")
    .get_pacts_for_verification(
      enable_pending: true,
      provider_version_tag: "main",
      include_wip_pacts_since: "2020-01-01",
      consumer_version_selectors: [{ tag: "production", latest: true }])
    .verify_pact(
      index: 0,
      provider_version_tag: "main",
      provider_version: "1",
      success: true
    )
    .publish_pact(consumer: "foo-consumer", consumer_version: "2", provider: "bar-provider", content_id: "112", tag: "main")
    .publish_pact(consumer: "foo-consumer", consumer_version: "3", provider: "bar-provider", content_id: "112", tag: "feat-1")
    .get_pacts_for_verification(
      enable_pending: true,
      provider_version_tag: "main",
      include_wip_pacts_since: "2020-01-01",
      consumer_version_selectors: [{ tag: "production", latest: true }]
    )

rescue StandardError => e
  puts "#{e.class} #{e.message}"
  puts e.backtrace
  exit 1
end
