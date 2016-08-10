module LandingTool
  class LandingPageVariation < ActiveRecord::Base

    validates_presence_of :title, :uid, :landing_page, :url

    validates_uniqueness_of :url

    belongs_to :landing_page

    serialize :tags
    serialize :data

    before_save :compile_templates, :if => Proc.new { |lpv| !lpv.landing_page.archived? && !lpv.archived? }
    before_save :purge_templates, :if => Proc.new { |lpv| lpv.landing_page.archived? || lpv.archived? }
    after_destroy :purge_templates

    scope :active, -> { where('archived_at IS NULL and deactivated_at IS NULL') }

    include Concerns::Archivable
    include Concerns::Deactivatable
    include Concerns::UidIdentifiable

    def data
      self[:data] ||= {}
    end

    def tags
      self[:tags] ||= {}
    end

    def compile_templates
      # extract template into target folder
      ensure_folders
      Zip::File.open(landing_page.templates.path) do |zip_file|
        zip_file.each do |f|
          f_path = File.join(compiled_folder, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          File.delete(f_path) if File.exists?(f_path) unless f.directory?
          f.extract(f_path)

          ext = Pathname.new(f_path).extname.reverse.chomp('.').reverse
          if %w'html htm css js'.include?(ext)
            content = File.read(f_path)
            data.each { |k, v|
              content = content.gsub("{{#{k}}}", v)
            }
            File.open(f_path, 'w') { |ff| ff.write content }
          end
        end
      end
      if new_record?
        compiled_at = DateTime.now
      else
        self.update_column(:compiled_at, DateTime.now)
      end
    end

    def compiled_folder
      "public/landing-tool/compiled/#{uid}"
    end

    def compiled?
      !!compiled_at && Dir.exists?(compiled_folder)
    end

    def full_url
      "/" + url
    end

    def ensure_compiled_templates
      compile_templates unless compiled?
      true
    end

    private

    def purge_templates
      FileUtils.rm_rf(compiled_folder) if Dir.exists?(compiled_folder)
    end

    def ensure_folders
      FileUtils.mkdir_p compiled_folder
    end
  end
end