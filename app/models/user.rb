# frozen_string_literal: true

# User account model
class User < ApplicationRecord
  has_many :page_annotations
  devise :database_authenticatable, :rememberable, :omniauthable, omniauth_providers: [:github]
  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      user.nickname = provider_data.info.name
    end
  end
end
