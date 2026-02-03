const std = @import("std");
const Allocator = std.mem.Allocator;
const Writer = std.Io.Writer;

const fmt = @import("../fmt.zig");
const query = @import("../query.zig");
const Language = @import("../language.zig").Language;
const Booster = @import("Booster.zig");
const Card = @import("card.zig").Card;
const Legality = @import("Legality.zig");
const Image = @import("Image.zig");
const Serie = @import("Serie.zig");

const Set = @This();

pub const url = "sets";

pub const CardCount = struct {
    total: usize,
    official: usize,

    pub fn format(self: CardCount, writer: *Writer) Writer.Error!void {
        try writer.print("{{ .total = {d}, .official = {d} }}", .{ self.total, self.official });
    }
};

id: []const u8,
name: []const u8,
logo: ?Image = null,
symbol: ?[]const u8 = null,
cardCount: CardCount,
serie: Serie.Brief,
tcgOnline: ?[]const u8 = null,
releaseDate: []const u8,
legal: Legality,
cards: []const Card.Brief,
boosters: ?[]const Booster = null,

pub fn get(allocator: Allocator, language: Language, params: query.Get) !std.json.Parsed(Set) {
    var q: query.Query(Set, .one) = .init(allocator, params);
    return q.run(language);
}

pub fn all(allocator: Allocator, language: Language, params: Brief.Params) query.Iterator(Brief) {
    return Brief.iterator(allocator, language, params);
}

pub fn format(self: Set, writer: *Writer) Writer.Error!void {
    try writer.print("{{ .id = {s}, .name = {s},", .{ self.id, self.name });

    if (self.logo) |logo| {
        try writer.print(" .logo = {f},", .{logo});
    }

    if (self.symbol) |symbol| {
        try writer.print(" .symbol = {s},", .{symbol});
    }

    try writer.print(" .cardCount = {f}, .serie = {f}", .{ self.cardCount, self.serie });

    if (self.tcgOnline) |tcg_online| {
        try writer.print(" .tcgOnline = {s},", .{tcg_online});
    }

    try writer.print(" .releaseDate = {s}, .legal = {f},", .{ self.releaseDate, self.legal });

    try writer.print(" .cards = ", .{});
    try fmt.printSlice(Card.Brief, writer, "{f}", self.cards);
    try writer.writeByte(',');

    if (self.boosters) |boosters| {
        try writer.print(" .boosters = ", .{});
        try fmt.printSlice(Booster, writer, "{f}", boosters);
        try writer.writeByte(',');
    }

    try writer.print(" }}", .{});
}

pub const Brief = struct {
    pub const url = Set.url;
    pub const Params = query.ParamsFor(Brief);

    id: []const u8,
    name: []const u8,
    logo: ?Image = null,
    symbol: ?[]const u8 = null,
    cardCount: CardCount,

    pub fn get(allocator: Allocator, params: query.Get) !Brief {
        var q: query.Query(Brief, .one) = .init(allocator, params);
        return q.run();
    }

    pub fn iterator(allocator: Allocator, language: Language, params: Params) query.Iterator(Brief) {
        return .init(allocator, language, params);
    }

    pub fn format(self: Brief, writer: *Writer) Writer.Error!void {
        try writer.print("{{ .id = {s}, .name = {s},", .{ self.id, self.name });

        if (self.logo) |logo| {
            try writer.print(" .logo = {f},", .{logo});
        }

        if (self.symbol) |symbol| {
            try writer.print(" .symbol = {s},", .{symbol});
        }

        try writer.print(" .cardCount = {f} }}", .{self.cardCount});
    }
};
