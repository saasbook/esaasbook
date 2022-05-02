# frozen_string_literal: true

class Page < ApplicationRecord
  has_many :page_annotations
end
