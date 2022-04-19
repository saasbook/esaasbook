# frozen_string_literal: true

# Migration for creating the users table
class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.datetime :remember_created_at
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :nickname
      t.string :uid
      t.string :avatar_url
      t.string :provider, null: false

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
