# frozen_string_literal: true

# Migration
class CreatePageAnnotations < ActiveRecord::Migration[6.1]
  def change
    create_table :page_annotations do |t|
      t.integer :chapter
      t.integer :section
      t.string :annotation
      t.references :user
      t.timestamps
    end
  end
end
