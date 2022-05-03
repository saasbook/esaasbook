# frozen_string_literal: true

class PageAnnotation < ApplicationRecord
  belongs_to :user
  belongs_to :page
end
