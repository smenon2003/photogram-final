class AddUploadsourceToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :uploadsource, :string
  end
end
