#include <cassert>
#include <array>

#include "lock_free_stack.h"

LockFreeStack<int32_t> stack;

void TestPushPopTask()
{
    for (int32_t i = 0; i < 100; ++i) {
        stack.push(i);
        stack.pop();
    }
}

void TestPushTask()
{
    for (int32_t i = 0; i < 100; ++i) {
        stack.push(i);
    }
}

void TestPopTask()
{
    for (int32_t i = 0; i < 100; ++i) {
        stack.pop();
    }
}

void Test1()
{
    std::array<std::thread, 100> threads;
    for (int32_t i = 0; i < 100; ++i) {
        threads[i] = std::thread(TestPushPopTask);
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i].join();
    }

    assert(stack.IsEmpty());
}

void Test2()
{
    std::array<std::thread, 100> threads;
    for (int32_t i = 0; i < 100; ++i) {
        threads[i] = std::thread(TestPushTask);
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i].join();
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i] = std::thread(TestPopTask);
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i].join();
    }

    assert(stack.IsEmpty());
}

void Test3()
{
    std::array<std::thread, 100> threads;
    for (int32_t i = 0; i < 100; ++i) {
        threads[i] = std::thread(TestPushTask);
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i].join();
    }

    for (int32_t i = 0; i < 99; ++i) {
        threads[i] = std::thread(TestPopTask);
    }

    for (int32_t i = 0; i < 99; ++i) {
        threads[i].join();
    }

    assert(!stack.IsEmpty());
}

void Test4()
{
    std::array<std::thread, 100> threads;
    for (int32_t i = 0; i < 50; ++i) {
        threads[i] = std::thread(TestPushTask);
    }

    for (int32_t i = 50; i < 100; ++i) {
        threads[i] = std::thread(TestPopTask);
    }

    for (int32_t i = 0; i < 100; ++i) {
        threads[i].join();
    }

    // nothing can be said about final stack state
}

int32_t main()
{
    Test1();
    Test2();
    // Test3();
    Test4();

    return 0;
}
