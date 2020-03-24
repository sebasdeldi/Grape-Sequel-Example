Sequel.migration do
  change do
    create_table(:presentations) do
      primary_key :id
      foreign_key :movie_id, :movies, null: false
      Integer :available_places, default: 10
      Date :date, null: false
      String :week_day
    end
  end
end
