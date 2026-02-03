const std = @import("std");
const assert = std.debug.assert;

const sdk = @import("sdk");
const language: sdk.Language = .en;

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    var series = sdk.Serie.all(allocator, language, .{});
    if (try series.next()) |briefs| {
        defer briefs.deinit();

        for (briefs.value) |brief| {
            const serie = try sdk.Serie.get(allocator, language, .{
                .id = brief.id,
            });
            defer serie.deinit();

            std.debug.print("{f}\n", .{serie.value});

            break;
        }
    }

    var sets = sdk.Set.all(allocator, language, .{});
    if (try sets.next()) |briefs| {
        defer briefs.deinit();

        for (briefs.value) |brief| {
            const set = try sdk.Set.get(allocator, language, .{
                .id = brief.id,
            });
            defer set.deinit();

            std.debug.print("{f}\n", .{set.value});

            break;
        }
    }

    var cards = sdk.Card.all(allocator, language, .{});
    if (try cards.next()) |briefs| {
        defer briefs.deinit();

        for (briefs.value) |brief| {
            const card = try sdk.Card.get(allocator, language, .{
                .id = brief.id,
            });
            defer card.deinit();

            std.debug.print("{f}\n", .{card.value});

            break;
        }
    }
}
