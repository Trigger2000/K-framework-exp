#ifndef LOCK_FREE_STACK_H
#define LOCK_FREE_STACK_H

#include <atomic>
#include <memory>
#include <thread>

#include <stdio.h>

template<typename T>
class LockFreeStack {
public:
    void push(T const& data)
    {
        fwrite("0", sizeof(char), 1, log_file_);
        Node* const new_node = new Node(data);
        new_node->next_ = head_.load();
        while (!head_.compare_exchange_weak(new_node->next_, new_node));
    }

    std::shared_ptr<T> pop()
    {
        fwrite("1", sizeof(char), 1, log_file_);
        ++threads_in_pop_; 
        Node* old_head = head_.load();
        while (old_head && !head_.compare_exchange_weak(old_head, old_head->next_));

        // below code refers to garbage collection and does not simulated in TLA+ model
        std::shared_ptr<T> res;
        if(old_head) {
            res.swap(old_head->data_);
        }
        try_reclaim(old_head);
        return res;
    }

    bool IsEmpty()
    {
        return head_ == nullptr;
    }

private:
    struct Node {
        Node(T const& data) : data_(std::make_shared<T>(data)) {}

        std::shared_ptr<T> data_;
        Node* next_ = nullptr;
    };

    static void delete_nodes(Node* nodes)
    {
        while(nodes)
        {
            Node* next = nodes->next_;
            delete nodes;
            nodes = next;
        }
    }

    void try_reclaim(Node* old_head)
    {
        if (threads_in_pop_ == 1) {
            Node* nodes_to_delete = to_be_deleted_.exchange(nullptr);
            if (!--threads_in_pop_) {
                delete_nodes(nodes_to_delete);
            } else if (nodes_to_delete) {
                chain_pending_nodes(nodes_to_delete);
            }
            delete old_head;
        }
        else {
            chain_pending_node(old_head);
            --threads_in_pop_;
        }
    }

    void chain_pending_nodes(Node* nodes)
    {
        Node* last = nodes;
        while(Node* const next = last->next_)
        {
            last = next;
        }
        chain_pending_nodes(nodes, last);
    }

    void chain_pending_nodes(Node* first, Node* last)
    {
        last->next_ = to_be_deleted_;
        while(!to_be_deleted_.compare_exchange_weak(last->next_, first));
    }

    void chain_pending_node(Node* n)
    {
        chain_pending_nodes(n, n);
    }

    std::atomic<Node*> to_be_deleted_ = nullptr;
    std::atomic<unsigned> threads_in_pop_ = 0;
    std::atomic<Node*> head_ = nullptr;

    FILE *log_file_ = fopen("log.txt","w");
};

#endif // LOCK_FREE_STACK_H
