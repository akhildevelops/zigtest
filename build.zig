const std = @import("std");
modules: std.StringHashMap(*std.Build.Module),
builder: *std.Build,
test_folder: []const u8,
target: std.Build.ResolvedTarget,
optimize: std.builtin.OptimizeMode,

const Options = struct {
    test_folder: ?[]const u8 = null,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
};

const Self = @This();
pub fn init(b: *std.Build, test_options: Options) Self {
    var folder: []const u8 = undefined;
    if (test_options.test_folder) |f| {
        folder = f;
    } else {
        folder = "test";
    }
    const modules = std.StringHashMap(*std.Build.Module).init(b.allocator);
    return .{ .modules = modules, .builder = b, .test_folder = folder, .target = test_options.target, .optimize = test_options.optimize };
}

pub fn addModule(self: *Self, name: []const u8, module: *std.Build.Module) std.mem.Allocator.Error!void {
    try self.modules.put(name, module);
}
fn _import_module(self: Self, root_module: *std.Build.Module) void {
    var kv_iter = self.modules.iterator();
    while (kv_iter.next()) |kv| {
        root_module.addImport(kv.key_ptr.*, kv.value_ptr.*);
    }
}
pub fn register(self: *Self) (std.fs.Dir.OpenError || std.mem.Allocator.Error)!void {
    ////////////////////////////////////////////////////////////
    //// Unit Testing
    // Creates a test binary.
    // Test step is created to be run from commandline i.e, zig build test
    const test_step = self.builder.step("test", "Run tests from test folder");
    const test_dir = try std.fs.cwd().openDir(self.test_folder, .{ .iterate = true });
    var dir_iterator = try test_dir.walk(self.builder.allocator);
    while (try dir_iterator.next()) |item| {
        if (item.kind == .file) {
            const test_path = try std.fmt.allocPrint(self.builder.allocator, "{s}/{s}", .{ self.test_folder, item.path });
            const sub_test = self.builder.addTest(.{ .name = item.path, .root_source_file = self.builder.path(test_path), .target = self.target, .optimize = self.optimize });

            // Add Module
            self._import_module(&sub_test.root_module);

            // Creates a run step for test binary
            const run_sub_tests = self.builder.addRunArtifact(sub_test);

            const test_name = try std.fmt.allocPrint(self.builder.allocator, "test-{s}", .{item.path[0 .. item.path.len - 4]});

            // Create a test_step name
            const ind_test_step = self.builder.step(test_name, "Individual Test");
            ind_test_step.dependOn(&run_sub_tests.step);
            test_step.dependOn(&run_sub_tests.step);
        }
    }
}
pub fn build(_: *std.Build) void {}
