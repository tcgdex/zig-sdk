Basic usage
===

- Add the dependency to your project's `.zon` file: `zig fetch --save git+https://github.com/tcgdex/zig-sdk`

- Add the library to your code

```zig
const dependeny = b.dependency("sdk", .{}); // both args are optional
const module = dependency.module("sdk");
your_module.addImport("sdk", module);
```

- Use it, can see some usage under `examples`
