# frozen_string_literal: true

module Curate
  module Pages
    class AudioPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push('/assets/ui-bg_highlight-soft_100_eeeeee_1x100.png')
      end

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/audios/new')
      end

      def valid_page_content?
        has_content?("Describe Your Audio")
      end

      def has_input_fields?
        has_field?("audio[title]")
        has_field?("audio[rights]")
        has_css?("div.control-group.text.optional.audio_description")
      end
    end
  end
end
