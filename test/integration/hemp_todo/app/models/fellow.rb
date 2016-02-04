class Fellow < Hemp::BaseRecord
  to_table :fellows
  property :first_name, type: :text, nullable: false
  property :last_name, type: :text, nullable: false
  property :email, type: :text, nullable: false
  property :stack, type: :text, nullable: false

  create_table
end
