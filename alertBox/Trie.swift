import Foundation

class TrieNode<T: Hashable> {           // Node is component of the trie
    var value: T?                       // Value is the letter stored in each Node
    weak var parentNode: TrieNode?      // The node above that is linked with current Node
    var children: [T: TrieNode] = [:]   // The node below that is linked with current Node
    var isTerminating = false           // Whether the node is terminating
    var isLeaf: Bool {                  // Leaf means the node with no children, Just like leaves on trees
        return children.count == 0      // If the node has no children, then it's a leaf node
        
    }
    
    init(value: T? = nil, parentNode: TrieNode? = nil) { // This is a function to initialize the node
        self.value = value                               // Just for initialization
        self.parentNode = parentNode                     // Just for initialization
    }

    func add(value: T) {                                 // This is a function that adds a node
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}

/// A trie data structure containing words.  Each node is a single
/// character of a word.
class Trie: NSObject, NSCoding {
    typealias Node = TrieNode<Character>
    /// The number of words in the trie
    public var count: Int {
        return wordCount
    }
    /// Is the trie empty?
    public var isEmpty: Bool {
        return wordCount == 0
    }
    /// All words currently in the trie
    public var words: [String] {
        return wordsInSubtrie(rootNode: root, partialWord: "")
    }
    fileprivate let root: Node
    fileprivate var wordCount: Int
    
    /// Creates an empty trie.
    override init() {
        root = Node()
        wordCount = 0
        super.init()
    }

    required convenience init?(coder decoder: NSCoder) {
        self.init()
        let words = decoder.decodeObject(forKey: "words") as? [String]
        for word in words! {
            self.insert(word: word)
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.words, forKey: "words")
    }
}

extension Trie {
    
    func insert(word: String) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        for character in word.lowercased().characters {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }
        guard !currentNode.isTerminating else {
            return
        }
        wordCount += 1
        currentNode.isTerminating = true
    }
    

    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased().characters {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        return currentNode.isTerminating
    }
    


    func remove(word: String) {
        guard !word.isEmpty else {
            return
        }
        guard let terminalNode = findTerminalNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
        }
        wordCount -= 1
    }
}
