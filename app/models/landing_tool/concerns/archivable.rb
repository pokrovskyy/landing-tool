module LandingTool
  module Concerns::Archivable
    def archive!
      update_attribute(:archived_at, DateTime.now)
    end

    def unarchive!
      update_attribute(:archived_at, nil)
    end

    def archived?
      !!archived_at
    end
  end
end