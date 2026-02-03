const std = @import("std");
const Allocator = std.mem.Allocator;
const Writer = std.Io.Writer;

const fmt = @import("../fmt.zig");
const query = @import("../query.zig");
const Language = @import("../language.zig").Language;
const Image = @import("Image.zig");
const Set = @import("Set.zig");

const Serie = @This();

pub const url = "series";

sets: []const Set.Brief,
id: []const u8,
name: []const u8,
logo: ?Image = null,

pub fn get(allocator: Allocator, language: Language, params: query.Get) !std.json.Parsed(Serie) {
    var q: query.Query(Serie, .one) = .init(allocator, params);
    return q.run(language);
}

pub fn all(allocator: Allocator, language: Language, params: Brief.Params) query.Iterator(Brief) {
    return Brief.iterator(allocator, language, params);
}

pub fn format(self: Serie, writer: *Writer) Writer.Error!void {
    try writer.print("{{ ", .{});

    try writer.print(" .sets = ", .{});
    try fmt.printSlice(Set.Brief, writer, "{f}", self.sets);
    try writer.writeByte(',');

    try writer.print(" .id = {s}, .name = {s},", .{ self.id, self.name });

    if (self.logo) |logo| {
        try writer.print(" .logo = {f},", .{logo});
    }

    try writer.print(" }}", .{});
}

pub const Brief = struct {
    pub const url = Serie.url;
    pub const Params = query.ParamsFor(Brief);

    id: []const u8,
    name: []const u8,
    logo: ?Image = null,

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

        try writer.print(" }}", .{});
    }
};
