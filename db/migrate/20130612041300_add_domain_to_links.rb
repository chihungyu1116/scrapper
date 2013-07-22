class AddDomainToLinks < ActiveRecord::Migration
  def change
    add_column :links, :domain, :string
  end
end
