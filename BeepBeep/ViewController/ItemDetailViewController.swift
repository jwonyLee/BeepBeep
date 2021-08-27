//
//  ItemDetailViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/12.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import FloatingPanel

class ItemDetailViewController: UIViewController {
    // MARK: - Properties
    private let identifier: String = "ItemDetailCell"
    private let disposeBag: DisposeBag = DisposeBag()
    private let dateFormatter: RelativeDateTimeFormatter = RelativeDateTimeFormatter()
    let viewModel: ItemDetailViewModel = ItemDetailViewModel()

    // MARK: - View Properties
    private let answerTextView: UITextView = UITextView().then {
        $0.font = UIFont.pretendardBody
        $0.isEditable = false
        $0.backgroundColor = UIColor(named: "BeepGray")
        $0.textColor = .label
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    private let recordTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.pretendardTitle3
        $0.text = I18N.recordList.localized
        $0.textColor = .label
    }

    private let recordTableView: UITableView = UITableView(frame: .zero, style: .grouped)

    private lazy var floatingPanelController: FloatingPanelController = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        setTableView()
        setFloatingPanelController()
        setAnswerTextViewConstraints()
        setRecordTitleLabelConstraints()
        setTableViewConstraints()
        bindTableView()
        bindOutput()
    }
}

class RecordFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.375, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.125, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .full, .half:
            return 0.3
        default:
            return 0.0
        }
    }
}

// MARK: - Private
extension ItemDetailViewController {
    private var menuItems: [UIAction] {
        [
            UIAction(title: I18N.modify.localized, image: UIImage(systemName: "pencil"), handler: { _ in }),
            UIAction(title: I18N.delete.localized, image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in })
        ]
    }

    private var menu: UIMenu {
        UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }

    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = viewModel.item.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.pretendardHeadline]

        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                     image: UIImage(systemName: "ellipsis.circle"),
                                                                     primaryAction: nil,
                                                                     menu: menu)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(moreActionTapped))
        }
    }

    @objc
    private func moreActionTapped(_ sender: UIBarButtonItem) {
        if #available(iOS 14.0, *) {
        } else {
            let alert: UIAlertController = UIAlertController(title: nil, message: I18N.actionsheetMessage.localized, preferredStyle: .actionSheet)

            let deleteAction: UIAlertAction = UIAlertAction(title: I18N.modify.localized, style: .default, handler: { _ in })
            let saveAction: UIAlertAction = UIAlertAction(title: I18N.delete.localized, style: .destructive, handler: { _ in })
            let cancelAction: UIAlertAction = UIAlertAction(title: I18N.cancle.localized, style: .cancel, handler: { _ in })

            alert.addAction(deleteAction)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }
    }

    private func configureViews() {
        view.addSubview(answerTextView)
        view.addSubview(recordTitleLabel)
        view.addSubview(recordTableView)
    }

    private func setTableView() {
        recordTableView.backgroundColor = .none
        recordTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
    }

    private func setFloatingPanelController() {
        floatingPanelController.view.frame = self.view.bounds
        floatingPanelController.delegate = self
        floatingPanelController.layout = RecordFloatingPanelLayout()
        floatingPanelController.contentMode = .fitToBounds

        let appearance: SurfaceAppearance = SurfaceAppearance()
        appearance.cornerRadius = 20.0

        floatingPanelController.surfaceView.appearance = appearance

        let recordViewController: RecordViewController = RecordViewController()
        recordViewController.setItem(at: viewModel.item)
        floatingPanelController.set(contentViewController: recordViewController)

        floatingPanelController.addPanel(toParent: self)
    }

    private func setAnswerTextViewConstraints() {
        answerTextView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(32)
            $0.top.equalTo(view.snp.topMargin).offset(32)
            $0.trailing.equalTo(view.snp.trailing).offset(-32)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.3)
        }
    }

    private func setRecordTitleLabelConstraints() {
        recordTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(answerTextView.snp.leading)
            $0.top.equalTo(answerTextView.snp.bottom).offset(32)
            $0.trailing.equalTo(answerTextView.snp.trailing)
        }
    }

    private func setTableViewConstraints() {
        recordTableView.snp.makeConstraints {
            $0.leading.equalTo(answerTextView.snp.leading)
            $0.top.equalTo(recordTitleLabel.snp.bottom)
            $0.trailing.equalTo(answerTextView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }

    private func bindOutput() {
        answerTextView.text = viewModel.item.content
    }

    private func bindTableView() {
        viewModel.recordObservable
            .bind(to: recordTableView.rx.items) { [weak self] _, row, record in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: self?.identifier)
                cell.textLabel?.text = self?.dateFormatter.localizedString(for: record.createDate, relativeTo: Date())
                cell.detailTextLabel?.textColor = .systemGray
                cell.detailTextLabel?.text = record.interval.stringTime
                return cell
            }
            .disposed(by: disposeBag)

        recordTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.recordTableView.deselectRow(at: indexPath, animated: true)
                self.viewModel.play(at: indexPath.row)
            }
            .disposed(by: disposeBag)

        recordTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.viewModel.deleteItem(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}

extension ItemDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanelShouldBeginDragging(_ fpc: FloatingPanelController) -> Bool {
        fpc.state == FloatingPanelState.tip ? false : true
    }

    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .tip:
            fpc.surfaceView.grabberHandle.isHidden = true
            // TODO: 핸들바를 이용해 강제로 fpc를 .tip으로 줄였으면, 녹음 버튼을 종료 상태로 변경한다.
        default:
            fpc.surfaceView.grabberHandle.isHidden = false
        }
    }
}
