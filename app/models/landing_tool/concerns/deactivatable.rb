module LandingTool
  module Concerns::Deactivatable
    def activate!
      update_attribute(:deactivated_at, nil)
    end

    def deactivate!
      update_attribute(:deactivated_at, DateTime.now)
    end

    def active?
      !deactivated_at
    end

    def inactive?
      !active?
    end
  end
end