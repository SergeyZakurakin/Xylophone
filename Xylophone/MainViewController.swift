//
//  ViewController.swift
//  Xylophone
//
//  Created by Sergey Zakurakin on 30/05/2024.
//

import UIKit
import AVFoundation

final class MainViewController: UIViewController {

    private let SoundButtons = ["A", "B", "C", "D", "E", "F", "G"]
    private let buttonStackView = UIStackView()
  
    private var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraint()
        createButtons()
    }
    
    private func createButtons(){
        for (index, soundButton) in SoundButtons.enumerated() {
            let multiplierWidth = 0.97 - (0.03 * Double(index))
            createButton(name: soundButton, width: multiplierWidth)
        }
    }

    private func createButton(name: String, width: Double) {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(name, for: .normal)
        button.addTarget(self, action: #selector(buttonsPressed), for: .touchUpInside)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 45)
        
        buttonStackView.addArrangedSubview(button)
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true
        
        button.backgroundColor = getColor(for: name)
    }
    
    @objc private func buttonsPressed(_ sender: UIButton) {
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.3) {
                sender.alpha = 1.0
            }
        }
        guard let buttonText = sender.currentTitle else {return}
        playSound(buttonText)
    }
    
    private func playSound(_ soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "wav") else {
            print("Звук не найден для кнопки \(soundName)")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getColor(for name: String) -> UIColor{
        switch name {
        case "A": return .systemRed
        case "B": return .systemOrange
        case "C": return .systemYellow
        case "D": return .systemGreen
        case "E": return .systemIndigo
        case "F": return .systemBlue
        case "G": return .systemPurple
        default: return .white
        }
    }
}

extension MainViewController {
    func setupViews() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        view.backgroundColor = .white
        view.addSubview(buttonStackView)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
