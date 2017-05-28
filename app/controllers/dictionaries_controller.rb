class DictionariesController < ApplicationController
  require 'ostruct'

  before_filter :authenticate_user!

  def show
    redirect_to check_word_dictionary_path
  end

  def check_word
    in_params = params['search'] || { word: '' }

    @search = OpenStruct.new(in_params)
    @dict = Dictionary.new(@locale)
    @word = @search.word.mb_chars.downcase

    if @word.length < 2 or @word.length > 15
      @error = t('word.out_of_boundries')
    else
      @found = @dict.check?(@word)
    end

    respond_to do |format|
      format.html
      format.js do
        render json: { found: @found, word: @word, locale: @locale }
      end
    end
  end


  def find_words
    in_params = params['search'] || { chars: '', from_to: '1,15' }

    @search = OpenStruct.new(in_params)
    @dict = Dictionary.new(@locale)

    @chars = @search.chars.mb_chars.downcase
    @from, @to = @search.from_to.split(',')

    chars = {}
    (1..15).each do |i|
      ff = 'ch_#{i}'
      unless  in_params[ff].blank?
        chars[i-1] = in_params[ff].mb_chars.downcase
      end
    end

    @prepositions = {
      from: @from.to_i - 1,
      to: @to.to_i - 1,
      chars: chars
    }

    @words = @dict.valid_words_from_chars(@chars, @prepositions)
  end
end
