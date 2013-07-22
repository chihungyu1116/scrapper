class AddFailedToLinks < ActiveRecord::Migration
  def change
    add_column :links, :failed, :boolean
  end
end
