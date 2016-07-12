class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_tool_landing_pages do |t|
      t.string :title
      t.string :uid
      t.text :notes
      t.string :category
      t.text :tags
      t.text :options
      t.datetime :deactivated_at
      t.datetime :archived_at

      t.timestamps null: false
    end
    add_attachment :landing_tool_landing_pages, :templates
  end
end
