class SaasbookController < ApplicationController
  before_action :annotation_ajax_prep, only: %i[annotate fetch_annotations]
  def index
    @body_contents = 'index'
    @chapter_id = 0
    @section_id = 0
    render('book_content')
  end

  def preface
    @body_contents = 'preface'
    @chapter_id = 0
    @section_id = 1
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
    @section_id = -1
    @body_contents = "chapter#{@chapter_id}"

    render('book_content')
  end

  def search
    @chapter_id = -1
    @section_id = -1
    @search_params = params[:q]
    @body_contents = 'search'

    render('book_content')
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
