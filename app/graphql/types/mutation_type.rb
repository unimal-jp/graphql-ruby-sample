Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :signup, function: Resolvers::CreateUser.new
  field :createLink, function: Resolvers::CreateLink.new
  field :createVote, function: Resolvers::CreateVote.new
  field :login, function: Resolvers::SignInUser.new
end
