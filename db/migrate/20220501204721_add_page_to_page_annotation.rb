# frozen_string_literal: true

# Adds a page reference to the page annotations table
class AddPageToPageAnnotation < ActiveRecord::Migration[6.1]
  def change
    add_reference :page_annotations, :page, null: false, foreign_key: true
  end
end
