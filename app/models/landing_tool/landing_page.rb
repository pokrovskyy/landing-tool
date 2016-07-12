module LandingTool
  class LandingPage < ActiveRecord::Base

    validates_presence_of :title, :uid, :templates

    has_many :variations, :class_name => 'LandingPageVariation', :dependent => :destroy

    has_attached_file :templates
    validates_attachment_content_type :templates, :content_type => %w{application/zip}

    serialize :tags
    serialize :options

    before_save :parse_templates, :if => Proc.new { |lp| !lp.archived? }
    after_save {
      self.variations.map(&:compile_templates) if self.templates_updated_at_changed?
    }

    scope :active, -> { where('archived_at IS NULL and deactivated_at IS NULL') }

    include Concerns::Archivable
    include Concerns::Deactivatable
    include Concerns::UidIdentifiable

    def self.tags
      Rails.cache.fetch('landing_page_tags2', :expires_in => 15.minutes) do
        LandingTool::LandingPage.all.map { |lp|
          lp.tags
        }.flatten.uniq.compact.map(&:strip).reject(&:blank?)
      end
    end

    def self.categories
      Rails.cache.fetch('landing_page_categories2', :expires_in => 15.minutes) do
        LandingTool::LandingPage.pluck(:category).uniq.compact.map(&:strip).reject(&:blank?)
      end
    end

    def options
      self[:options] ||= []
    end

    def tags
      self[:tags] ||= {}
    end

    private

    def parse_templates
      self.options = []
      Zip::File.open((templates.queued_for_write[:original] || templates).path) do |zip_file|
        # Handle entries one by one
        zip_file.each do |entry|
          next if entry.directory?
          ext = Pathname.new(entry.name).extname.reverse.chomp('.').reverse
          if %w'html htm css js'.include?(ext)
            entry.get_input_stream.read.scan(/{{\s*[\w\.]+\s*}}/) { |var|
              var = var[2..-3]
              self.options << var unless options.include?(var)
            }
          end
        end
      end
    end
  end
end