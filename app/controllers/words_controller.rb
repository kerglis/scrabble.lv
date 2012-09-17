class WordsController < ApplicationController

  require 'ostruct'

  before_filter :authenticate_user!

  def check
    in_params = params["search"] || { :word => "" }

    @search = OpenStruct.new(in_params)
    @word = Dictionary.find_by_word_and_locale(@search.word.mb_chars.downcase, @locale)
    @error = t("search_word_out_of_boundries") if @search.word.length < 2 or @search.word.length > 15

    respond_to do |format|
      format.html
      format.js do
        render :json => { :found => @word.present?, :word => @search.word, :locale => @locale }
      end
    end
  end

end