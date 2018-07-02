//
//  ViewController.swift
//  iTunes-Search
//
//  Created by Javier Loucim on 30/06/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import UIKit
import IGListKit

enum MediaTypeSelection: String {
    case movies = "movie"
    case tvShows = "tvShow"
    case music = "music"
}
class ViewController: UIViewController,Alertable {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var closeIconImageView: UIImageView!
    @IBOutlet weak var musicButtonView: UIView!
    @IBOutlet weak var moviesButtonView: UIView!
    @IBOutlet weak var tvShowsButtonView: UIView!
    @IBOutlet weak var selectionBarImageView: UIImageView!
    @IBOutlet weak var selectionBarLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isLoading:Bool = false
    var buttonSize:CGFloat = 0
    var currentTypeSelection:MediaTypeSelection = .music
    var currentSearchTerm:String = ""
    let disabledAlpha:CGFloat = 0.2
    
    var mediaCollection:Array<Media> = Array<Media>()
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    //MARK: - Functions
    func setupViews() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)

        closeIconImageView.alpha = 0
        closeIconImageView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToClearText))

        moviesButtonView.alpha = self.disabledAlpha
        tvShowsButtonView.alpha = self.disabledAlpha
        
        musicButtonView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToSelectMusic))
        moviesButtonView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToSelectMovies))
        tvShowsButtonView.respondToSelectorOnTap(target: self, selector: #selector(userWantsToSelectTvShows))
        buttonSize = selectionBarImageView.bounds.size.width
        
    }
    @objc fileprivate func search(text:String) {
        isLoading = true
        reloadData()
        searchForMedia(type: self.currentTypeSelection, containing: text)
    }

    func reloadData() {
        adapter.performUpdates(animated: true, completion: nil)
        collectionView.scrollToTop()
    }
    
    //MARK: - Animations
    func showCloseIconAnimation() {
        self.closeIconImageView.isHidden = false
        UIView.animate(withDuration: 0.37, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]
            , animations: {
                self.closeIconImageView.alpha = 1
        }, completion: nil)
    }
    
    func hideCloseIconAnimation() {
        UIView.animate(withDuration: 0.37, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]
            , animations: {
                self.closeIconImageView.alpha = 0
        }, completion: nil)
    }
    
    func selectMoviesAnimation() {
        self.selectionBarLeadingConstraint.constant = self.buttonSize*1
        UIView.animate(withDuration: 0.57, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]
            , animations: {
                self.moviesButtonView.alpha = 1
                self.musicButtonView.alpha = self.disabledAlpha
                self.tvShowsButtonView.alpha = self.disabledAlpha
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func selectMusicAnimation() {
        self.selectionBarLeadingConstraint.constant = 0
        UIView.animate(withDuration: 0.57, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]
            , animations: {
                self.moviesButtonView.alpha = self.disabledAlpha
                self.musicButtonView.alpha = 1
                self.tvShowsButtonView.alpha = self.disabledAlpha
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func selectTVShowAnimation() {
        self.selectionBarLeadingConstraint.constant = self.buttonSize*2
        UIView.animate(withDuration: 0.57, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]
            , animations: {
                self.moviesButtonView.alpha = self.disabledAlpha
                self.musicButtonView.alpha = self.disabledAlpha
                self.tvShowsButtonView.alpha = 1
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func restartSearchIfNeeded() {
        if self.currentSearchTerm.count > 0 {
            self.mediaCollection.removeAll()
            search(text: self.currentSearchTerm)
        }
    }
    //MARK: - Actions
    @objc func userIsWriting() {
        if let text = searchField.text, text.count > 0 {
            showCloseIconAnimation()
        }
    }
    @objc func userWantsToClearText() {
        searchField.text = ""
        currentSearchTerm = ""
        mediaCollection = Array<Media>()
        searchField.becomeFirstResponder()
        reloadData()
        hideCloseIconAnimation()
    }
    @objc func userWantsToSelectMovies() {
        guard currentTypeSelection != .movies else { return }
        currentTypeSelection = .movies
        selectMoviesAnimation()
        restartSearchIfNeeded()
    }
    @objc func userWantsToSelectMusic() {
        guard currentTypeSelection != .music else { return }
        currentTypeSelection = .music
        selectMusicAnimation()
        restartSearchIfNeeded()
    }
    @objc func userWantsToSelectTvShows() {
        guard currentTypeSelection != .tvShows else { return }
        currentTypeSelection = .tvShows
        selectTVShowAnimation()
        restartSearchIfNeeded()
    }
}
//MARK: - MediaHandler
extension ViewController: MediaHandler {
    func mediaHandlerFunctionHadErrors(errorMessage: String) {
        isLoading = false
        showErrorMessage(message: errorMessage)
    }
    func mediaHasBeenFound(type: MediaTypeSelection, mediaCollection: Array<Media>) {
        isLoading = false
        self.mediaCollection = mediaCollection
        reloadData()
    }
    
}
//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldDidChange(textField: textField)
        return true
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text {
            if text.count > 0 {
                showCloseIconAnimation()
            } else {
                hideCloseIconAnimation()
            }
            searchField.text = text.uppercased()
            currentSearchTerm = text.uppercased()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(search), with: text, afterDelay: 0.5)
        } else {
            hideCloseIconAnimation()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textFieldDidChange(textField: textField)
        return true
    }
}
//MARK: - MediaCollectionViewCellDelegate
extension ViewController: MediaCollectionViewCellDelegate, AppNavigationController {
    func userWantsToSeeMedia(type: MediaTypeSelection, media: Media) {
        navigateToMediaPlayback(type: type, media: media)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

//MARK: - ListAdapterDataSource
extension ViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects:Array<ListDiffable> = Array<ListDiffable>()
        
        if mediaCollection.count > 0 {
            let spacer = IGListKitSpacer()
            spacer.id = "TopSpacer"
            spacer.color = .clear
            spacer.size = CGSize(width: 0, height: 24)
            objects.append(spacer)
        }
        
        for item in mediaCollection {
            objects.append(item.diffable())
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is IGListKitSpacer:
            return SpacerSectionController(spacer: object as! IGListKitSpacer)
        case is DiffableBox<Media>:
            return MediaSectionController(type: self.currentTypeSelection, delegate: self)
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        
        let emptyState = EmptyStateView.initFromNib()
        emptyState.frame = self.collectionView.frame
        if isLoading {
            emptyState.configureAsLoader()
        } else {
            emptyState.configure(with: currentSearchTerm.count > 0 ? "No media found!" : "")
        }
        return emptyState
        
    }
    
}

