import UIKit

class ViewController: UIViewController {
    
    var wordTrie = Trie()
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentDisplay: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var wordlist = [String]()
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

