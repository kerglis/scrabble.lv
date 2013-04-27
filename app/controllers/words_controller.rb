class WordsController < ApplicationController

  require 'ostruct'

  before_filter :authenticate_user!

  def check
    in_params = params["search"] || { :word => "" }

    @search = OpenStruct.new(in_params)
    @dict = Dictionary.new(@locale)
    @word = @search.word.mb_chars.downcase

    if @word.length < 2 or @word.length > 15
      @error = t("search_word_out_of_boundries")
    else
      @found = @dict.check?(@word)
    end

    respond_to do |format|
      format.html
      format.js do
        render :json => { :found => @found, :word => @word, :locale => @locale }
      end
    end
  end

end