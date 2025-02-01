const clap = @import("clap");
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const params = comptime clap.parseParamsComptime(
        \\-h, --help            "Print this help message and exit"
        \\-l, --list            "List locally installed versions"
        \\-r, --listremote     "List remotely available versions"
        \\-s, --set <str>       "Set the active version"
        \\-i, --install <str>   "Install a version"
        \\-u, --uninstall <str> "Uninstall a version"
        \\-c, --clean           "Clears local files."
    );

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = allocator,
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    // TODO : Make this customizable. Somehow. Maybe through the build step.
    const vmname = "ivm";
    // FIXME : This is not portable "~". What to do for windows ?
    const HOMEDIR = try std.process.getEnvVarOwned(allocator, "HOME");
    defer allocator.free(HOMEDIR);

    // TODO : How should this be configured ? Through the build step ? Some config file ? IDK
    // Maybe: "$HOME/.local/$VMNAME/"
    const vmpath = try std.fmt.allocPrint(allocator, "{s}/.local/{s}", .{ HOMEDIR, vmname });
    defer allocator.free(vmpath);

    try makeAllDirsIfNotExist(allocator, vmpath);

    if (res.args.help != 0) {
        var args = std.process.args();
        const program_name = args.next() orelse return error.Unexpected;
        std.debug.print("Usage: {s} ", .{program_name});
        try clap.usage(std.io.getStdErr().writer(), clap.Help, &params);
        std.debug.print("\n\n", .{});
        try clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
        std.debug.print("\n", .{});
    }

    if (res.args.clean != 0) {
        std.debug.print("Clearing local files\n", .{});
        try std.fs.deleteTreeAbsolute(vmpath);
    }

    if (res.args.list != 0) {
        std.debug.print("Versions:\n", .{});

        const version_dirs_path = try std.fmt.allocPrint(allocator, "{s}/version", .{vmpath});
        defer allocator.free(version_dirs_path);

        var dir = try std.fs.openDirAbsolute(version_dirs_path, .{ .iterate = true });
        defer dir.close();

        var dir_iter = dir.iterate();
        while (try dir_iter.next()) |version| {
            // TODO : Format
            std.debug.print("{s}\n", .{version.name});
        }
    }

    if (res.args.listremote != 0) {
        std.debug.print("Listing remote versions\n", .{});
        unreachable;
    }

    if (res.args.set) |version| {
        std.debug.print("Setting active version: {s}\n", .{version});
        unreachable;
    }
}

fn makeAllDirsIfNotExist(allocator: std.mem.Allocator, vmpath: []u8) !void {
    try makeDirIfNotExist(vmpath);

    const versions_dir = try std.fmt.allocPrint(allocator, "{s}/version", .{vmpath});
    defer allocator.free(versions_dir);
    try makeDirIfNotExist(versions_dir);
}

fn makeDirIfNotExist(path: []u8) !void {
    var tmpVmDirOpt = std.fs.openDirAbsolute(path, .{}) catch {
        return std.fs.makeDirAbsolute(path);
    };
    defer tmpVmDirOpt.close();
}
