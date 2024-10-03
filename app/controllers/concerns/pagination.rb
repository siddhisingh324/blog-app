# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern
  def page_meta(object, meta = {})
    meta[:pagination] = {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
    meta
  end
end
