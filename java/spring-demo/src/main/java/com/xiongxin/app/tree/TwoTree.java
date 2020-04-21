package com.xiongxin.app.tree;

import java.util.Iterator;

public class TwoTree {

    public static void main(String[] args) {
        BinarySearchTree<Integer> tree = new BinarySearchTree<>();

        tree.insert(3);
        tree.insert(2);
        Node<Integer> one = new Node<>(1);
        tree.insert(one);
        tree.insert(5);
        tree.insert(4);
        tree.insert(6);


        System.out.println(tree.successor(one));
        System.out.println(tree.contains(11));

        Node<Integer> node = new Node<>(1);
        setNode(node);

        System.out.println(node);
        System.out.println(tree.sr());
    }

    private static void setNode(Node<Integer> node) {
        node.data = 1000;
    }
}




class Node<T> {
    T data;
    Node left;
    Node right;
    Node parent;


    Node(T d) {
        this.data = d;
    }

    @Override
    public String toString() {
        return "Node{" + "\n" +
                "data=" + data + "\n" +
                ", left=" + left + "\n" +
                ", right=" + right + "\n" +
//                ", parent=" + parent + "\n" +
                '}'+ "\n";
    }
}

/**
 * 1. 结点的左孩子都比该结点小
 * 2. 结点的右孩子都比该结点大
 * 3.
 * @param <T>
 */
class BinarySearchTree<T extends Comparable<T>> {
    private Node<T> root;
    boolean insert(Node<T> newNode) {
        if (root == null) {
            root = newNode;

            return true;
        }

        Node current = root;

        while (true) {
            // 如果i比当前结点的值小
            if (newNode.data.compareTo((T) current.data) < 0) {
                if (current.left != null) {
                    current = current.left;
                } else {
                    Node node = newNode;
                    node.parent = current;
                    current.left = node;
                    break;
                }
            } else {
                if (current.right != null) {
                    current = current.right;
                } else {
                    Node node = newNode;
                    node.parent = current;
                    current.right = node;
                    break;
                }
            }
        }

        return true;
    }
    boolean insert(T i) {
        return insert(new Node<>(i));
    }

    @SuppressWarnings("unchecked")
    boolean contains(T t) {
        boolean find = false;

        if (root == null) {
            return find;
        }

        Node current = root;

        while (true) {
            if (t.compareTo((T) current.data) < 0) {
                current = current.left;
                if (current == null) break;
            } else if (t.compareTo((T) current.data) > 0){
                current = current.right;
                if (current == null) break;
            } else {
                find = true;
                break;
            }

        }

        return find;
    }


    /**
     * 从某个结点触发找到最小结点
     * @param n
     * @return
     */
    Node<T> min(Node<T> n) {
        if (n == null) return null;

        Node<T> node = null;
        if (n.left != null) {
            for (Node<T> l = n.left; l != null; l = l.left) {
                node = l;
            }
        }

        return node;
    }

    public Node<T> min() {
        return min(root);
    }

    public Node<T> successor(Node<T> n) {
        if (n == null) {
            return null;
        }

        if (n.right != null) { // 右结点不为空时，找到右结点最小值
            return min(n.right);
        }

        if (n.left == null && n.right == null) {

            if (n == n.parent.left) { // 要查询的结点是左结点
                return n.parent;
            }

        }

        return null;
    }


    public Node<T> sr() {
        return successor(root);
    }

    private class Itr implements Iterator<T> {


        @Override
        public boolean hasNext() {
            return false;
        }

        @Override
        public T next() {
            return null;
        }
    }

    @Override
    public String toString() {
        return "BinarySearchTree{" +
                "root=" + root +
                '}';
    }
}


// 3 3 3 2