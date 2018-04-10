class Resolvers::CreateUser < GraphQL::Function
  AuthProviderInput = GraphQL::InputObjectType.define do
    name 'AuthProviderSignupData'

    argument :credentials, Types::AuthProviderEmailInput
  end

  argument :name, !types.String
  argument :credentials, Types::AuthProviderEmailInput

  type do
    name 'SignupPayload'

    field :token, types.String
    field :user, Types::UserType
  end

  def call(_obj, args, ctx)
    user = User.create!(
      name: args[:name],
      email: args[:credentials][:email],
      password: args[:credentials][:password]
    )

    token = AuthToken.token_for_user(user)

    ctx[:session][:token] = token

    OpenStruct.new(
      user: user,
      token: token
    )
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
