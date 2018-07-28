class Types::QueryType < Types::BaseObject
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # TODO: Add authentication
  # TODO: Add authorization
  field :email, Types::EmailType, null: true, description: "A single email" do
    argument :id, ID, required: true
  end

  def email(id:)
    email = Delivery.find_by(id: id)
    raise GraphQL::ExecutionError, "Email doesn't exist" if email.nil?
    email
  end

  field :emails, [Types::EmailType], null: true, description: "All emails"

  # TODO: Add pagination
  # TODO: Add authentication
  # TODO: Filter by app name
  # TODO: Filter by sent/bounced etc..
  def emails
    Pundit.policy_scope(context[:current_admin], Delivery)
  end

  field :configuration, Types::ConfigurationType, null: false
  def configuration
    Rails.configuration
  end

  field :viewer, Types::ViewerType, null: true
  def viewer
    context[:current_admin]
  end
end