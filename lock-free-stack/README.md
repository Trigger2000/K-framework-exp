## Correctness properties

1. Once a value is added to the stack, it can safely be retrieved immediately by another thread;
2. Only one thread returns a given value;
3. After all operations stack should be empty

## TLA model
In TLA+ model only push/pop stack interfaces were verified. Garbage collection with reference counter was not modeled.