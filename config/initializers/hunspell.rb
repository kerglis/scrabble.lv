module FFI
  module Hunspell

    def Hunspell.directories
      @directories = [ "#{Rails.root}/lib/dicts/" ]
    end

  end
end