module StdCrud

  def self.included(base)
    base.class_eval do

      [:destroy, :restore, :swap].each do |method|
        define_method method do |arg| 
          self.send "#{method}_object"
        end
      end
    end
  end

end
