class CreateLandingPageVariations < ActiveRecord::Migration
  def change
    create_table :landing_tool_landing_page_variations do |t|
      t.integer :landing_page_id
      t.string :title
      t.string :uid
      t.text :notes
      t.string :url
      t.text :tags
      t.text :data
      t.datetime :compiled_at
      t.datetime :deactivated_at
      t.datetime :archived_at

      t.timestamps null: false
    end
  end
end
