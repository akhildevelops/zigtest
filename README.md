# zigtest

Registers test steps from test folder of your application.

Run `zig build test-<filename in test folder>` to run the tests of a specific file.

Run `zig build test` to run all the tests from all files in test directory.

Goto [zensor/build.zig](https://github.com/akhildevelops/zensor/blob/d3abaf1d787b7beff20cc3bd2ad3da8059040803/build.zig#L10-L12) for understanding interaction with zigtest.

## Setup
Fetch and save zigtest dependency in the project by:
```zig
zig fetch --save https://github.com/akhildevelops/zigtest/archive/refs/heads/main.zip
```

Have the below lines the project's build.zig file, refer to [zensor/build.zig](https://github.com/akhildevelops/zensor/blob/d3abaf1d787b7beff20cc3bd2ad3da8059040803/build.zig#L10-L12) as an example

```zig
var zigTestBuilder = zigtest.init(b, .{ .target = target, .optimize = optimize });
try zigTestBuilder.addModule(<your_root_module_name>, <your_root_module>);
try zigTestBuilder.build();
```

Setup is completed to run all tests or separately.
