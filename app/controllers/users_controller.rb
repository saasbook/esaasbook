# frozen_string_literal: true

# Application Controller for user accounts
class UsersController < ApplicationController
  before_action :authenticate_user!
  def profile
    @annotations = current_user.page_annotations.order(:chapter, :section)
    @anno_nodes = list_anno_with_path(@annotations) unless @annotations.nil?

    @chapter_id = 0
    @section_id = -1
    @body_contents = 'user_page'
    @title = "#{current_user.nickname}'s User Page"
    render('main_content')
  end

  # Returns the correct route for a given page
  def get_path_from_page(page)
    @section = page.section
    @chapter = page.chapter
    special_path_handler(@section) if @chapter.zero?
    section_path(chapter_id: @chapter, section_id: @section) if @chapter.positive? && @section.positive?
  end

  def special_path_handler(section)
    home_path if section.zero?
    preface_path if section.negative?
  end

  # Returns a page title given a page object
  # Includes chapter and section number
  def get_title_from_page(page)
    @section = page.section
    @chapter = page.chapter
    if @chapter.positive?
      if @section.positive?
        "#{@chapter}.#{@section} #{page.title}"
      else
        "#{@chapter}.0 #{page.title}"
      end
    else
      page.title
    end
  end

  def list_anno_with_path(_annotations)
    anno_entry = Struct.new(:title, :link)
    @anno_nodes = []

    @annotations&.each do |x|
      @anno_nodes.append(anno_entry.new(get_title_from_page(x.page), get_path_from_page(x.page))) unless x.annotation == '[]'
    end
    @anno_nodes
  end
end
