import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private let alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IB Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        setEnabledForButtons(false)
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        setEnabledForButtons(false)
        presenter.yesButtonClicked()
    }
    
    // MARK: - Internal Methods
    
    func setLoading(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func setBorderForImageView(isCorrect: Bool?) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        imageView.layer.cornerRadius = 20.0
        if let isCorrect {
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        } else{
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setEnabledForButtons(_ enabled: Bool) {
        noButton.isEnabled = enabled
        yesButton.isEnabled = enabled
    }
    
    func show(quiz nextQuestion: QuizQuestion) {
        let viewModel = presenter.convert(model: nextQuestion)
        show(quiz: viewModel)
    }
    
    func show(quiz result: QuizResultViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func showNetworkError(message: String) {
        setLoading(false)
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "OK") { [weak self] in
            guard let self else { return }
            
            presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: - Private Methods
    
    private func show(quiz step: QuizStepViewModel) {
        setBorderForImageView(isCorrect: nil)
        imageView.image = UIImage(data: step.image) ?? UIImage()
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
}
