package com.xiongxin.app.tree;

public class AVLNode {
    public static void main(String[] args) {


        AVLNode avlNode = new AVLNode(100);
        avlNode.insert(avlNode, 120); // avlNode: depth 2,balance 0 - 1 = -1, 120: depth: 1, balance: 0
        avlNode.insert(avlNode, 30);  // avlNode: depth 2,balance 1 - 1 = 0, 20: depth: 1, balance: 0
        avlNode.insert(avlNode, 20);
        avlNode.insert(avlNode, 10);  // avlNode: depth 3,balance 2 - 1 = 1  ,20 depth: 2, balance 1 - 0 = 1
        avlNode.insert(avlNode, 9);   // avlNode: depth 4,balance 3 - 1 = 2, 20: depth 3 balance 2 - 0 = 2,10 depth 2, balance 1 - 0  = 1

        System.out.println(avlNode);
    }


    public int data;
    public int depth;
    public int balance;
    public AVLNode parent;
    public AVLNode left;
    public AVLNode right;

    public AVLNode(int data) {
        this.data = data;
        depth = 1;
        balance = 0;
        left = null;
        right = null;
        parent = null;
    }


    private void insert(AVLNode root, int data) {
        if (data < root.data) {
            if (root.left != null) {
                insert(root.left, data);
            } else {
                root.left = new AVLNode(data);
                root.left.parent = root;
            }
        }
        else {
            if (root.right != null) {
                insert(root.right, data);
            } else {
                root.right = new AVLNode(data);
                root.right.parent = root;
            }
        }

        root.balance = calcBalance(root);// 发现20的平衡因子是２了

        // 平衡处理
        if (root.balance >= 2) {   // 8<-10<-20<-100->120
            // 右旋结点
            right_rotate(root);
        }

        root.balance = calcBalance(root);
        root.depth = calcDepth(root);
    }

    /**
     *
     * @param p
     */
    void right_rotate(AVLNode p) { // 20
        // balance 为２的作为新的root
//        System.out.println(p);
        AVLNode left = p.left; // 30
        AVLNode parent = p.parent; // null
        AVLNode rightChild = left.right; // null

        p.left = rightChild;
        p.parent = left;
        left.right = p;

        if ( parent != null) {
            if (rightChild != null) {
                rightChild.parent = p;
            }
        }

        p.depth = calcDepth(p);
        p.balance = calcBalance(p);

//        right.depth = calcDepth(right);
//        right.balance = calcBalance(right);
    }

    private int calcBalance(AVLNode p) {
        int left_depth;
        int right_depth;

        if (p.left != null)
            left_depth = p.left.depth;
        else
            left_depth = 0;

        if (p.right != null)
            right_depth = p.right.depth;
        else
            right_depth = 0;

        return left_depth - right_depth;
    }

    private int calcDepth(AVLNode p) {
        int depth = 0;

        if (p.left != null) {
            depth = p.left.depth;
        }

        if (p.right != null && depth < p.right.depth) {
            depth = p.right.depth;
        }

        depth++;

        return depth;
    }

    @Override
    public String toString() {
        return "AVLNode{" + "\n" +
                "data=" + data + "\n" +
                ", depth=" + depth + "\n" +
                ", balance=" + balance + "\n" +
//                ", parent=" + parent +
                ", left=" + left + "\n" +
                ", right=" + right + "\n" +
                '}' + "\n";
    }
}
