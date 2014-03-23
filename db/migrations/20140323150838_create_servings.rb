Sequel.migration do
  up do                                                                                                                                                      
    create_table(:servings) do
      primary_key :id

      Time :started_at
      Time :stopped_at

      foreign_key :beer_id, :beers
      index :beer_id

      foreign_key :keg_id, :kegs
      index :keg_id

      foreign_key :line_id, :lines
      index :line_id
    end
  end

  down do
    drop_table(:servings)
  end
end
