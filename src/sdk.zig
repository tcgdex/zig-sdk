// TODO: on `jsonParse()`, figure out what to do with allocated vs non-allocated
//       is it good as is, or shall we perform have to allocation/free?

const graphqlz = @import("graphqlz");

pub const Booster = @import("types/Booster.zig");
pub const Card = @import("types/card.zig").Card;
pub const Image = @import("types/Image.zig");
pub const Iterator = @import("query.zig").Iterator;
pub const Language = @import("language.zig").Language;
pub const Legality = @import("types/Legality.zig");
pub const Pricing = @import("types/Pricing.zig");
pub const Serie = @import("types/Serie.zig");
pub const Set = @import("types/Set.zig");

pub const graphql = struct {
    pub const schema = @import("graphql/schema.zig");
    pub const run = graphqlz.Client("https://api.tcgdex.net/v2/graphql", schema).execute;
};
