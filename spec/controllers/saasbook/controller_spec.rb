# spec/controllers/saasbook/
require 'rails_helper'




RSpec.describe SaasbookController do
  describe "GET '/chapter/1/section/1'" do
    it "renders the appropriate view" do
      get show_section, params: {chapter_id: 1, section_id: 1}
      # expect(response).to render_template('chapter1section1')
    end
  end
end
