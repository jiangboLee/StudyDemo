//
//  PageViewController.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    private let petCards = PetCardStore.defultPets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setViewControllers([viewControllerForPage(at: 0)], direction: .forward, animated: false, completion: nil)
    }

}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CardViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex > 0
        else { return nil }
        return viewControllerForPage(at: pageIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? CardViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex + 1 < petCards.count
            else { return nil }
        return viewControllerForPage(at: pageIndex + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return petCards.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewControllers = pageViewController.viewControllers,
            let currentVC = viewControllers.first as? CardViewController,
            let currentPageIndex = currentVC.pageIndex
            else { return 0 }
        
        return currentPageIndex
    }
    
    private func viewControllerForPage(at index: Int) -> UIViewController {
        let cardViewController: CardViewController = UIStoryboard(storyboard: .main).instantiateViewController()
        cardViewController.pageIndex = index
        cardViewController.petCard = petCards[index]
        return cardViewController
    }
    
}







