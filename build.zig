const std = @import("std");

// project/executable name
const name = "main";

// project files list
const sources = [_][]const u8{ // zig syntax is garbage xdx
    "src/main.c"
};

// compilation flags to treat all warnings as errors
const flags = &.{
    "-Wall",
    "-Werror",
    //"-Wswitch-enum"
};

// raylib paths
const raylib_source_directory = "../raylib";
const raylib_build_directory = raylib_source_directory ++ "/zig-out";
const raylib_include_directory = raylib_build_directory ++ "/include";
const raylib_library_directory = raylib_build_directory ++ "/lib";


fn linkRaylib(b: *std.Build, m: *std.Build.Module) void {
    // equivalent to zig cc -I"/path/to/includes": add to include search paths
    //  so that #include "raylib.h" would actually work
    m.addIncludePath(b.path(raylib_include_directory));

    // equivalent to zig cc -L"/path/to/libraries": add to library search paths
    //  so that raylib.lib was actually found
    m.addLibraryPath(b.path(raylib_library_directory));

    // equivalent to zig cc -llibname: "import" library into the executable
    //  so that raylib.lib was actually imported
    m.linkSystemLibrary("raylib", .{});

    // raylib dependencies on Windows SDK
    m.linkSystemLibrary("winmm", .{});
    m.linkSystemLibrary("gdi32", .{});
    m.linkSystemLibrary("opengl32", .{});
}


pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // build in debug mode by default
    const optimize = b.option(std.builtin.OptimizeMode, "optimize", "Optimization mode") orelse .Debug;

    const module = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    for (sources) |src| {
        module.addCSourceFile(.{ .file = b.path(src), .flags = flags });
    }
    linkRaylib(b, module); // import raylib
    module.link_libc = true; // import standard C library as well (mandatory)

    const exe = b.addExecutable(.{
        .name = name,
        .root_module = module,
    });
    b.installArtifact(exe); // actually build it


    // add command to build and immediately run executable
    const r = b.addRunArtifact(exe);
    // pass command line arguments to your executable:
    //  $> zig build run -- arg1 arg2
    if (b.args) |args| {
        r.addArgs(args);
    }
    // register command
    const step = b.step("run", "Build and run the program");
    step.dependOn(&r.step);
}
