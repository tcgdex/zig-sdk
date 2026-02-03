const std = @import("std");
const assert = std.debug.assert;

const sdk = @import("sdk");
const language: sdk.Language = .en;

pub fn main() !void {
    @setEvalBranchQuota(5_000);

    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    const series_response = try sdk.graphql.run(allocator, "series", .{}, .{
        .id = true,
    });
    defer series_response.deinit();
    if (try series_response.unwrap()) |series| {
        std.debug.print("{s}\n", .{series[0].id});
    }

    const sets_response = try sdk.graphql.run(allocator, "sets", .{}, .{
        .id = true,
    });
    defer sets_response.deinit();
    if (try sets_response.unwrap()) |sets| {
        std.debug.print("{s}\n", .{sets[0].id});
    }

    const cards_response = try sdk.graphql.run(allocator, "cards", .{}, .{
        .id = true,
    });
    defer cards_response.deinit();
    if (try cards_response.unwrap()) |cards| {
        std.debug.print("{s}\n", .{cards[0].id});
    }
}
