# frozen_string_literal: true

# Controller for the Saasbook website. Temporary maybe?
class SaasbookController < ApplicationController
  def index
    # Do Nothing
  end

  def show_section
    @chapter_id = params[:chapter_id]
    @section_id = params[:section_id]

    # This will eventually be replaced with a database + model construction
    render("chapter#{@chapter_id}section#{@section_id}")
  end

  def show_chapter
    @chapter_id = params[:chapter_id]

    # This will eventually be replaced with a database + model construction
    render("chapter#{@chapter_id}")
  end
end
