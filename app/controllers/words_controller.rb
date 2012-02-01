class WordsController < BaseController

  require 'ostruct'

  before_filter :authenticate_user!

  def check
    in_params = params["search"] || { :word => "" }

    @search = OpenStruct.new(in_params)
    @word = Dictionary[@search.word, @locale]

  end

end