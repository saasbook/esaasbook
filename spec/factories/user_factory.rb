# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'gob_github@githubtest.com' }
    full_name { 'Gob Github' }
    provider { 'github' }
    uid { 43_231 }
    created_at { Time.current }
    updated_at { Time.current }
    encrypted_password { '1234asdf4312fdsa' }
  end
end
