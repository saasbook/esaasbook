# frozen_string_literal: true

# Controller for the Saasbook website
# #index, #preface, #show_section and #show_chapter help render the correct content for the page
# #search enables search function on the web page
# #annotation_ajax_prep prepares the ajax call to create an annotation
# #annotate updates/creates an annotation object for the user
# #fetch_annotations retrive all the annotations the user has made in JSON format
class SaasbookController < ApplicationController
  before_action :annotation_ajax_prep, only: %i[annotate fetch_annotations]
  def index
    @body_contents = 'index'
    @title = 'Engineering Software as a Service: An Agile Approach Using Cloud Computing'
    @chapter_id = 0
    @section_id = 0
    render('main_content')
  end

  def preface
    @body_contents = 'preface'
    @title = 'Preface'
    @chapter_id = 0
    @section_id = 1
    render('main_content')
  end

  def show_section
    @chapter_id = params[:chapter_id]
    @section_id = params[:section_id]
    @title = Page.where(chapter: @chapter_id, section: @section_id)[0].title
    @title = "#{@chapter_id}.#{@section_id}. #{@title}"
    @body_contents = "chapter#{@chapter_id}section#{@section_id}"

    render('main_content')
  end

  def show_chapter
    @chapter_id = params[:chapter_id]
    @section_id = -1
    @title = Page.where(chapter: @chapter_id, section: @section_id)[0].title
    @title = "#{@chapter_id}. #{@title}"

    @body_contents = "chapter#{@chapter_id}"

    render('main_content')
  end

  def search
    @chapter_id = -1
    @section_id = -1
    @search_params = params[:q]
    @body_contents = 'search'

    @title = "Search the Book - #{@search_params} "
    render('main_content')
  end

  def annotation_ajax_prep
    @chapter = params[:chapter]
    @section = params[:section]
    @user = current_user
  end

  def annotate
    return unless user_signed_in?

    @anno = @user.page_annotations.where(chapter: @chapter, section: @section).first_or_create
    @anno.update(annotation: params[:annotation])
  end

  def fetch_annotations
    respond_to do |format|
      format.html { redirect_to home_path }
      format.json
    end

    return unless user_signed_in?

    @anno = @user.page_annotations.find_by(chapter: @chapter, section: @section)

    @anno = @anno.annotation unless @anno.nil?

    render json: @anno.to_json
  end
end
