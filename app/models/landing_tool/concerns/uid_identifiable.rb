module LandingTool
  module Concerns::UidIdentifiable

    def self.included(base)
      base.class_eval do
        validates_uniqueness_of :uid

        before_validation {
          self.uid = SecureRandom.hex(16) if self.uid.blank?
        }

        def self.by_uid(uid)
          where(:uid => uid).first
        end
      end
    end

  end
end