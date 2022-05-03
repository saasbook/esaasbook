# frozen_string_literal: true

# spec/spec_helper.rb
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'features'
  add_filter 'spec'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/helpers/application_helper.rb'
  add_filter 'app/javascript/packs/jquery-3.5.1.js'
  add_filter 'app/javascript/packs/language_data.js'
  add_filter 'app/javascript/packs/searchtools.js'
  add_filter 'app/javascript/packs/underscore-1.13.1.js'
  add_filter 'app/javascript/packs/underscore-1.12.0.js'
  add_filter 'app/javascript/packs/doctools.js'
end
