class Resolvers::SignInUser < GraphQL::Function
  argument :credentials, Types::AuthProviderEmailInput

  type do
    name 'SigninPayload'

    field :token, types.String
    field :user, Types::UserType
  end

  def call(_obj, args, ctx)
    input = args[:credentials]

    return unless input

    user = User.find_by email: input[:email]

    return unless user
    return unless user.authenticate(input[:password])

    token = AuthToken.token_for_user(user)

    ctx[:session][:token] = token

    OpenStruct.new(
      user: user,
      token: token
    )
  end
end
