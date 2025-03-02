class AddLateToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :late, :boolean, default: false
  end
end
