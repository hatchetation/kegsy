Sequel.migration do
  up do
    create_table(:lines) do
      primary_key :id
    end
  end

  down do
    drop_table(:lines)
  end
end
