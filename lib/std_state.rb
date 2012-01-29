module StdState

  def self.included(base)
    base.class_eval do

      scope :not_deleted,   { :conditions => "#{table_name}.state != 'deleted' " }
      scope :active,        { :conditions => "#{table_name}.state  = 'active'  " }

      state_machine :initial => :inactive do
        after_transition do |o, t|
          # call do_after_[transition]... if any
          mm = "do_after_#{t.to_name.to_s}".to_sym
          o.send(mm) if o.respond_to?(mm)
        end

        event :activate do
          transition :to => :active, :from => :inactive 
        end

        event :archive do
          transition :to => :archived, :from => :active
        end

        event :deactivate do
          transition :to => :inactive, :from => :active
        end

        event :delete do
          transition :to => :deleted
        end

        event :restore do
          transition :to => :inactive, :from => :deleted
        end

        event :swap do
          transition  :active => :inactive, :inactive => :active
        end
      end
    end

    def deletable?
      ! self.deleted? rescue true
    end

    def restorable?
      self.deleted? rescue false
    end

  end

end