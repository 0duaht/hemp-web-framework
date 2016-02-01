class Fellow < Hemp::BaseRecord
  to_table :fellows
  property :id, type: :integer, primary_key: true
  property :first_name, type: :text, nullable: false
  property :last_name, type: :text, nullable: false
  property :email, type: :text, nullable: false
  property :stack, type: :text, nullable: false

  create_table
end
