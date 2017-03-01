module Curate
  module Pages
    # /
    class CollectionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'Collection'
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('div.applied-constraints') do
          has_content?("Collection")
        end
        has_checked_field?('works_mine')
      end
    end
  end
end
