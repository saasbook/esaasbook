# frozen_string_literal: true

# Controller for the Saasbook website. Temporary maybe?
class SaasbookController < ApplicationController
  def index
    @body_contents = 'index'
    render('book_content')
  end

  def preface
    @body_contents = 'preface'
    render('book_content')
  end

  def show_section
    @chapter_id = params[:chapter_id]
    @section_id = params[:section_id]

    @body_contents = "chapter#{@chapter_id}section#{@section_id}"

    render('book_content')
  end

  def show_chapter
    @chapter_id = params[:chapter_id]
    @body_contents = "chapter#{@chapter_id}"

    render('book_content')
  end
end
