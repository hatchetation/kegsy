Sequel.migration do
  up do
    create_table(:beers) do
      primary_key :id
      String :name
    end
  end

  down do
    drop_table(:beers)
  end
end
