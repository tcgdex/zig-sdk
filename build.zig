const std = @import("std");

// TODO: configure language using an option?
// pro: simple setup, cleaner code
// con: same exe can't query cards in different languages

pub fn build(b: *std.Build) void {
    // options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // deps
    const graphqlz = b.dependency("graphqlz", .{
        .target = target,
        .optimize = optimize,
    });

    const sdk = b.addModule("sdk", .{
        .root_source_file = b.path("src/sdk.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "graphqlz", .module = graphqlz.module("graphqlz") },
        },
    });

    // steps
    const g2z_step = b.step("g2z", "run g2z");
    const g2z_cmd = b.addRunArtifact(graphqlz.artifact("g2z"));
    g2z_step.dependOn(&g2z_cmd.step);
    if (b.args) |args| g2z_cmd.addArgs(args);

    // examples
    const rest = b.addExecutable(.{
        .name = "rest",
        .root_module = b.createModule(
            .{
                .root_source_file = b.path("examples/rest.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "sdk", .module = sdk },
                },
            },
        ),
    });
    const rest_step = b.step("rest", "run REST example");
    rest_step.dependOn(&b.addRunArtifact(rest).step);

    const graphql = b.addExecutable(.{
        .name = "graphql",
        .root_module = b.createModule(
            .{
                .root_source_file = b.path("examples/graphql.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "sdk", .module = sdk },
                },
            },
        ),
    });
    const graphql_step = b.step("graphql", "run GraphQL example");
    graphql_step.dependOn(&b.addRunArtifact(graphql).step);
}
