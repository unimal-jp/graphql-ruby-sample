Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :node, GraphQL::Relay::Node.field

  field :feed, function: Resolvers::LinksSearch
  field :_feedMeta, Types::QueryMetaType do
    resolve ->(_obj, _args, _ctx) { Link.count }
  end
end
