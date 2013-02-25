class DropProvServices < ActiveRecord::Migration
	def change
		drop_table :prov_services
	end
end
