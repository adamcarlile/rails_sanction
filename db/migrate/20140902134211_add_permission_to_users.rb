class AddPermissionToUsers < ActiveRecord::Migration
  def change
    args = [RailsSanction.config.user_model.table_name, RailsSanction.config.storage_column]
    case connection.adapter_name.downcase.to_sym
    when :postgresql
      add_column *args, :json
    else
      add_column *args, :text
    end
  end
end
