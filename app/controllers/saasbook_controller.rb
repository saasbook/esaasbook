# frozen_string_literal: true

# Controller for the Saasbook website. Temporary maybe?
class SaasbookController < ApplicationController
  def index
    @body_contents = 'index'
    @title = "Engineering Software as a Service: An Agile Approach Using Cloud Computing"
    render('book_content')
  end

  def preface
    @body_contents = 'preface'
    @title = "Preface"
    render('book_content')
  end

  def show_section
    @chapter_id = params[:chapter_id]
    @section_id = params[:section_id]
    @title = Page.where(chapter: @chapter_id, section: @section_id)[0].title
    @title = @chapter_id + "." + @section_id.to_s + ". " + @title
    @body_contents = "chapter#{@chapter_id}section#{@section_id}"

    render('book_content')
  end

  def show_chapter
    @chapter_id = params[:chapter_id]
    @section_id = 0
    @title = Page.where(chapter: @chapter_id, section: @section_id)[0].title
    @title = @chapter_id + ". " + @title
    @body_contents = "chapter#{@chapter_id}"

    render('book_content')
  end

  def search
    @search_params = params[:q]
    @body_contents = 'search'
    @title = "Search the Book - #{@search_params} "
    render('book_content')
  end

  def annotate
    return unless user_signed_in?

    @chapter = params[:chapter]
    @section = params[:section]
    @user = current_user
    @anno = @user.page_annotations.where(chapter: @chapter, section: @section).first_or_create
    @anno.update(annotation: params[:annotation])
  end

  def fetch_annotations; end
end
