# frozen_string_literal: true
require 'active_support/core_ext/module/delegation'

module Curate
  module Pages
    # /catalog
    class CatalogPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :search_term, :category, :departmental_link

      LOOKUP_CATEGORY_URL = {
        thesis: "/catalog?f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Doctoral+Dissertation&f_inclusive%5Bhuman_readable_type_sim%5D%5B%5D=Master%27s+Thesis",
        article: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Article",
        dataset: "/catalog?f%5Bhuman_readable_type_sim%5D%5B%5D=Dataset"
      }.freeze
      LOOKUP_CATEGORY_CAPTION = {
        thesis: "Theses & Dissertations",
        article: "Articles & Publications",
        dataset: "Datasets & Related Items"
      }.freeze
      LOOKUP_CATEGORY_VALUE = {
        thesis: "Doctoral Dissertation OR Master's Thesis",
        article: "Article",
        dataset: "Dataset"
      }.freeze
      LOOKUP_CATEGORY_FILTER = {
        thesis: "Type of Work:",
        article: "Type of Work:",
        dataset: "Type of Work:",
        department: "Department or Unit:"
      }.freeze

      def initialize(search_term: nil, category: nil, departmental_link: nil)
        @search_term = search_term
        @category = category
        @departmental_link = departmental_link
      end

      delegate :count, :link, :caption, to: :departmental_link, allow_nil: true

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          valid_search_constraint? &&
          valid_content_count?
      end

      def on_valid_url?
        if category.nil? && search_term.nil?
          current_url.start_with?(File.join(Capybara.app_host, 'catalog'))
        elsif category.nil?
          current_url.start_with?(File.join(Capybara.app_host, 'catalog')) &&
            current_url.include?(search_term)
        elsif caption.nil?
          current_url == File.join(Capybara.app_host, LOOKUP_CATEGORY_URL.fetch(category))
        else # use caption link
          current_url == link
        end
      end

      def on_base_url?
        current_url == File.join(Capybara.app_host, 'catalog')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.sidebar') do
          return false unless has_content?('Filter by:')
        end
        return true if category.nil?
        within('h1') do
          has_content?(category_caption)
        end
      end

      def category_caption
        return caption unless caption.nil?
        LOOKUP_CATEGORY_CAPTION.fetch(category)
      end

      def valid_search_constraint?
        return true if search_term.nil? && category.nil?
        valid_search_content? &&
          valid_filter_value? &&
          valid_filter_name?
      end

      def valid_search_content?
        within('.search-constraint-notice') do
          return false unless has_content?('Search criteria:')
        end
        true
      end

      def valid_filter_value?
        within('.filter-value') do
          return false unless has_content?(filter_value)
        end
        true
      end

      def filter_value
        return caption unless caption.nil?
        return LOOKUP_CATEGORY_VALUE.fetch(category) unless category.nil?
        search_term
      end

      def valid_filter_name?
        return true if category.nil?
        within('.filter-name') do
          return false unless has_content?(LOOKUP_CATEGORY_FILTER.fetch(category))
        end
        true
      end

      def valid_content_count?
        return true if count.nil?
        count == find_page_count
      end

      def find_page_count
        within('.page_links') do
          node = find('.page_entries')
          node_list = node.all('strong')
          return node_list[2].text
        end
      end
    end
  end
end
