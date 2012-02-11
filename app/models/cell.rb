class Cell < ActiveRecord::Base
  
  belongs_to      :game

  state_machine :initial => :free do
    event :try do
      transition :to => :pending, :from => :free
    end

    event :use do
      transition :to => :used, :from => [ :free, :pending ]
    end

    event :free do
      transition :to => :free, :from => [ :used, :pending ]
    end
  end

  
end
