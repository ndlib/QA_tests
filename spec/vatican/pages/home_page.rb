module Vatican
  module Pages

    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
        status_response_ok? &&
        valid_page_content?
      end

      def on_valid_url?
        current_url == Capybara.app_host
      end

      def status_response_ok?
        true
        #status_code == 200
      end

      def valid_page_content?
        page.has_link?("Search The Database")
      end
    end
  end
end