class Sleep < ActiveRecord::Base
  QUALITY = {"5 - Serene" => 5, "3 - Okay" => 3, "1 - Abysmal" => 1, "2 - Restless" => 2, "4 - Restful" => 4, " "=>" "}
  QUALITY_BACKWARDS = {5 => "5 - Serene", 3 => "3 - Okay", 1 => "1 - Abysmal", 2 => "2 - Restless", 4 => "4 - Restful", " "=>" "}
  belongs_to :user
  
	validate :not_a_time_traveller?
	validate :sleep_is_reasonable?
	validate :no_overlap?

	private
	def not_a_time_traveller?
	  if stop < start
	    errors.add(:start, "Stop time must not be before start time.")
	    errors.add(:stop, "Stop time must not be before start time.")
    end
  end
	
	def sleep_is_reasonable?
	  if (stop - start) > 86400.to_f
	    errors.add(:start, "One sleep event can't be more than 24 hours past start time. If you really slept that long add more events.")
	    errors.add(:stop, "One sleep event can't be more than 24 hours past start time. If you really slept that long add more events.")
    end
  end
  
  def no_overlap?
    @sleeps = Sleep.find(:all, :conditions => ["user_id=?", user_id])
    for sleep in @sleeps
      unless start > sleep.stop || stop < sleep.start || sleep.id = id
        errors.add(:id, "Sleep events cannot overlap, one of your sleeps overlaps with this entry.<br />
        According to your yawnlog you were already sleeping from #{sleep.start.strftime("%I:%M%p %a, %m/%d/%y")} to #{sleep.stop.strftime("%I:%M%p %a, %m/%d/%y")} so you probably weren't also sleeping from #{start.strftime("%I:%M%p %a, %m/%d/%y")} to #{stop.strftime("%I:%M%p %a, %m/%d/%y")}")
      end
    end
  end
end
