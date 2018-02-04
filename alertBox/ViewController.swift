import UIKit

// "var" is for defining a variable. A variable stores a value that you can change afterward
// "let" is for defining a constant. A constant stores a value that you cannot change afterward
// "func" is for defining a function. A function takes in (or not) parameters, and do something (like calculation), and returns a value (or not)
// An array stores several values together
// A stirng array looks like this ["thing","thing","thing"]
// An array of numbers looks like this [1,2,3]



class ViewController: UIViewController {
    
    var wordTrie = Trie() // Trie is a stand-alone file in this project. In order to use it, we need to define a variable that is equal to "Trie.swift" in order to use the functions inside
    
    @IBOutlet weak var inputText: UITextField!      // This is just a reference of the text Box on the screen
    @IBOutlet weak var imageView: UIImageView!      // This is just a reference of the image on the screen
    @IBOutlet weak var commentDisplay: UILabel!     // This is just a reference of comment display area on the screen
    
    
    
    
    override func viewDidLoad() {   // If you want to see something on the screen right after the app is loaded, write code inside
        super.viewDidLoad()         // Don't need to understand this
        var wordlist = [String]()   // An array of string
        if let path = Bundle.main.url(forResource: "wordList", withExtension: "txt"){
            do{
                let data = try String(contentsOf: path, encoding: .utf8)
                let strings = data.components(separatedBy: .newlines)
                wordlist = strings
            }catch{
                print(error)
            }
            print(wordlist.count)
        }
        
        let imageUrl = URL(string:"https://picsum.photos/300/200/?image=1084")
        let data = try? Data(contentsOf:imageUrl!)
        
        imageView.image = UIImage(data:data!)
        
    
        for word in wordlist{
            wordTrie.insert(word: word)
        }
        self.hideKeyboardWhenTappedAround() 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func randomImage() -> Int{
        return Int(arc4random_uniform(1000))
    }
    
    
    
    
    
    func alert(input:String){
        let alert = UIAlertController(title: "Are you sure?", message: "This message may contain explicit or sensitive content that may offend or psychologically harm others.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let readMoreAction = UIAlertAction(title: "Read More", style: .default) { (action) in
            UIApplication.shared.open(URL(string:"https://help.instagram.com/478745558852511")!, options: [:], completionHandler: nil)
        }
        let proceedAction = UIAlertAction(title: "Proceed", style:.destructive){(action) in
            self.commentDisplay.text = input
        }
        alert.addAction(cancelAction)
        alert.addAction(readMoreAction)
        alert.addAction(proceedAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func noSensitiveWord(){
        let alert = UIAlertController(title: "Well done!", message: "Really friendly comment!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func create(_ sender: UIButton) {
        let input = inputText.text
        var sensitiveWords = 0
        var strings = [String]()
        
        if let toConvert = input{
            strings = toConvert.components(separatedBy: " ")
        }
        
        for word in strings{
            if wordTrie.contains(word:word){
                sensitiveWords += 1
            }
        }
        if sensitiveWords > 0{
            alert(input:input!)
        }else{
            noSensitiveWord()
            commentDisplay.text = input!
        }
        
        print(sensitiveWords)

    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        let num = randomImage()
        let stringfiednum = String(num)
        print(stringfiednum)
        let newLink = "https://picsum.photos/200/300/?random"
        let url = URL(string:newLink)
        let data = try? Data(contentsOf:url!)
        imageView.image = UIImage(data:data!)
        
        
        
        
    }
    
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

