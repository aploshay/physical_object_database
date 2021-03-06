class CreateEightMillimeterVideoTms < ActiveRecord::Migration
  def change
    create_table :eight_millimeter_video_tms do |t|
      t.string :pack_deformation
      t.boolean :fungus
      t.boolean :soft_binder_syndrome
      t.boolean :other_contaminants
      t.string :recording_standard
      t.string :format_duration
      t.string :tape_stock_brand
      t.string :image_format
      t.string :format_version
      t.string :playback_speed
      t.string :binder_system

      t.timestamps
    end
  end
end
