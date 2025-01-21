const clap = @import("clap");
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const params = comptime clap.parseParamsComptime(
        \\-h, --help            "Print this help message and exit"
        \\-l, --list            "List locally installed versions"
        \\-r, --listremote     "List remotely available versions"
        \\-s, --set <str>       "Set the active version"
        \\-i, --install <str>   "Install a version"
        \\-u, --uninstall <str> "Uninstall a version"
    );

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0) {
        var args = std.process.args();
        const program_name = args.next() orelse return error.Unexpected;
        std.debug.print("Usage: {s} ", .{program_name});
        try clap.usage(std.io.getStdErr().writer(), clap.Help, &params);
        std.debug.print("\n\n", .{});
        try clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
        std.debug.print("\n", .{});
    }
    if (res.args.list != 0) {
        std.debug.print("Listing local versions\n", .{});
        return error.NotImplemented;
    }
    if (res.args.listremote != 0) {
        std.debug.print("Listing remote versions\n", .{});
        return error.NotImplemented;
    }
    if (res.args.set) |version| {
        std.debug.print("Setting active version: {s}\n", .{version});
        return error.NotImplemented;
    }
}
