Sequel.migration do
  change do
    create_table(:reservations) do
      primary_key :id
      foreign_key :presentation_id, :presentations, null: false
      String :reservation_code, null: false
    end
  end
end
