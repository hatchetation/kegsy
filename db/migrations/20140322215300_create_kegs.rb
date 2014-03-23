Sequel.migration do
  up do
    create_table(:kegs) do
      primary_key :id
      Float :volume
    end
  end

  down do
    drop_table(:kegs)
  end
end
