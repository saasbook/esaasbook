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

  def search
    @search_params = params[:q]
    @body_contents = 'search'

    render('book_content')
  end

  def annotate
    puts "Annotate is running!"
    unless user_signed_in?
      # Should error
      puts "UH OH"
    end
    @chapter = params[:chapter]
    @section = params[:section]
    @user = current_user
    @anno = @user.page_annotations.where(chapter: @chapter, section: @section).first_or_create
    @anno.update(annotation: params[:annotation])
  end

  def fetch_annotations; end
end
