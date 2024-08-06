# zigtest

Registers test steps from test folder of your application.

Run `zig build test-<filename in test folder>` to run the tests of a specific file.

Run `zig build test` to run all the tests from all files in test directory.

Goto [zensor/build.zig](https://github.com/akhildevelops/zensor/blob/8e4480dbcef53c22662ff0c5f7f47dcc3234f574/build.zig#L10-L12) for understanding interaction with zigtest.

## Setup
Fetch and save zigtest dependency in the project by:
```zig
zig fetch --save https://github.com/akhildevelops/zigtest/archive/refs/heads/main.zip
```

Have the below lines the project's build.zig file, refer to [zensor/build.zig](https://github.com/akhildevelops/zensor/blob/8e4480dbcef53c22662ff0c5f7f47dcc3234f574/build.zig#L10-L12) as an example

```zig
var zigTestBuilder = zigtest.init(b, .{ .target = target, .optimize = optimize, .package_name = <your_package_name> });
try zigTestBuilder.addModule(<your_root_module_name>, <your_root_module>);
try zigTestBuilder.register();
```

Setup is completed to run all tests or separately.
