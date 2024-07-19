# UniVoice_iOS

#### “다양한 목소리를 통해 더 나은 학생 사회, 더 나은 대학 생활을 만들기 위해서” <br> 
![유니보이스_브랜딩과제](https://github.com/user-attachments/assets/9fa19806-ade6-47a3-8245-49edcd773a31)

학생회와 학생들의 목소리로 함께 만들어가는 대학 생활 필수 앱, **유니보이스** 입니다.

- 34기 NOW SOPT APPJAM (2024.06.15 ~ )

<br>


## 🍎 iOS Developer

[박민서](https://github.com/FpRaArNkK) | [왕정빈](https://github.com/kingjeongkong) | [이자민](https://github.com/jaminleee) |[오연서](https://github.com/oyslucy) | 
| :--: | :--: | :--: | :--: |
| <img alt="민서" src="https://github.com/SOPKATHON-iOS-TEAM4/iOS/assets/84556636/3fd0433e-627d-48f6-bfa7-c62d460af2c9" width="350"/> | <img alt="정빈" src="https://github.com/user-attachments/assets/b747b1db-5a8a-4269-ae79-4de906095d92" width="350"/> | <img alt="자민" src= "https://github.com/user-attachments/assets/9affbd0f-939d-4320-a99a-ac46671a17c1" width="350"/> | <img alt="연서" src="https://github.com/user-attachments/assets/487e7556-9aef-4901-9be4-0220e4731544" width="350"/> |
| **[Team Leader]** <br> 로그인 <br> 퀵스캔 <br> 저장 페이지 | **[Team Member]** <br> 회원가입(학생증 후) <br> API 구조 설계 후 구현 | **[Team Member]** <br> 회원가입(학생증 전) <br> 공지사항 등록 | **[Team Member]** <br> 메인 홈 <br> 세부공지 확인 <br> 마이 페이지 |

<br>

## 📦 Libraries

| Library | Version | Description |
| --- | --- | --- |
| [SnapKit](https://github.com/SnapKit/SnapKit) | 5.7.1 | 레이아웃 코드의 직관성, 간결성 강화,  UI Constraint 설정 간단화 |
| [Then](https://github.com/devxoul/Then) | 3.0.0 | 객체를 초기화한 후 프로퍼티를 설정하는 과정 간단화, 가독성 증가 |
| [Moya](https://github.com/Moya/Moya) | 15.0.3 | 네트워크 로직의 추상화, 구조화, 확장성 증가 |
| [KingFisher](https://github.com/onevcat/Kingfisher) | 7.12.0 | 이미지 캐싱, 이미지 처리 간편성 |
| [RxSwift](https://github.com/ReactiveX/RxSwift) | 6.7.1 | 비동기 작업 관리 및 다양한 연산자를 활용한 데이터 스트림 처리 |
| [RxDataSource](https://github.com/ReactiveX/RxSwift) | 5.0.2 | 테이블 뷰와 컬렉션 뷰의 데이터 소스를 반응형으로 관리 및 데이터 바인딩을 간편하게 처리 |
| [RxMoya](https://github.com/Moya/Moya) | 15.0.3 | Moya를 사용하여 네트워크 요청을 관리하고, RxSwift를 통해 비동기 네트워크 작업을 처리 |
| [Lottie](https://github.com/airbnb/lottie-ios) | 4.5.0 | JSON 기반의 애니메이션을 쉽게 구현 |
<br>

## 📖 Coding Convention

### 1. Base Rule

- StyleShare 의 Swift Style Guide를 기본으로 합니다.
- 세부적인 사항은 아래 원칙을 따른다.

### 2. Naming
```
- 함수, 메서드 : lowerCamelCase 사용하고, 동사로 시작한다.
- 변수, 상수 : lowerCamelCase 사용한다.
- 클래스, 구조체, enum, extension 등 : UpperCamelCase 사용한다.
- 파일, 클래스 명 약어 사용. 단, UI 선언 구문과 메소드에서는 약어를 사용하지 않는다.
    - 예시) ViewController → `VC`
    - 예시) CollectionViewCell → `CVC`
- 뷰 설정을 위한 함수에서는 set 키워드를 사용한다.
    - 예시) func configureUI → `func setUI`
    - 예시) func setDelegate ... → `func configureDelegate`
- 이외 기본 명명규칙은 [Swift Style Guide]를 참고한다.
- 상속받지 않는 클래스는 final 키워드를 붙인다.
- 단일 정의 내에서만 사용되는 특정 기능 구현은 private 접근 제한자를 적극 사용한다.
- 퀵헬프기능을 활용한 마크업 문법을 활용한 주석을 적극 사용한다.
- 이외는 커스텀한 SwiftLint Rule을 적용한다.
- image asset 추가 시 img_{name}의 이름으로 작성한다. snakecase로 작성
- color asset 추가 시 Figma 네이밍을 따름.
```

### 3. 개행

- 모든 파일은 빈 줄로 끝나도록 합니다.
- MARK 구문의 **위에만 한 줄** 줄바꿈 합니다.
    
    ```swift
    // MARK: - Layout
    override func layoutSubviews() {
      // doSomething()
    }
    
    // MARK: - Actions
    override func menuButtonDidTap() {
      // doSomething()
    }
    
    ```
    
- 함수 줄바꿈은 다음과 같이 합니다.
    
    ```swift
    override func layoutSubviews() {
      // doSomething()
    }
    ```
    
- 함수 정의가 **너무 길어지면** 다음과 같이 줄바꿈합니다.
    
    파라미터 기준으로 줄바꿈하며,  리턴은 따로 줄바꿈하지 않습니다. 
    
    ```swift
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      // doSomething()
    }
    ```
    

- 함수 아래 한 칸, 클래스 아래 한 칸을 줄바꿈하며 의미없는 공백을 만들지 않습니다.
    
    ```swift
    func 함수1() {
    
    }
    
    func 함수2() {
    
    }
    ```
    

- 코드가 짧아도 줄을 바꿉니다.
    
    ```swift
    switch ~~ {
    	case 0:
                print("")
    }
    ```
    

### guard문

- guard문이 짧을 시 한 줄에 다 선언한다.
- guard문이 길 시, 아래와 같이 guard 문을 개행한다.
- 개행 시, `else`는 `guard`와 같은 들여쓰기를 적용한다.

```swift
guard let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
      let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
      user.gender == .female 
else { return }
```

<br>

## 🙌 Git Convention / Branch Strategy

### 1. Git-flow

```bash
git-flow에 사용되는 브랜치는 총 5개 입니다. 🖐️ (main과 develop, feature 필수 나머지는 optional)
- **main(master)**: 
    제품으로 출시될 수 있는 브랜치    
- **develop(개발)**:    
    다음 출시 버전을 개발하는 브랜치    
- **feature(기능)**:    
    기능을 개발하는 브랜치  
- **release(배포)**:  
    이번 출시 버전을 준비하는 브랜치(보통 QA를 여기서 함)   
- **hotfix(빨리 고치기)**:   
    출시 버전에서 발생한 버그를 수정 하는 브랜치
```

### 2. Prefix Convention
- [Feat] : 새로운 기능 추가 • 새로운 기능을 추가할 때 사용됩니다. 이전에 존재하지 않았던 새로운 기능이나 기능의 확장을 포함합니다.
- [Fix] : 버그 수정 • 기존 기능의 오류를 수정하는데 사용됩니다. 애플리케이션의 기능 또는 동작이 의도한 대로 작동하지 않을 때 사용됩니다.
- [Docs] : 문서 작성 • 문서를 추가하거나 변경할 때 사용됩니다. 주로 README 파일, 사용 설명서, 주석 등의 변경을 의미합니다.
- [Setting] : 프로젝트 세팅
- [Chore] : 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
- [Add] : 파일추가, 에셋추가 • 새로운 파일이나 코드의 추가에 사용됩니다. 새로운 파일이나 코드를 프로젝트에 추가할 때 사용됩니다.
- [Design] : UI 디자인을 변경했을 때
- [Refactor] : 전면 수정이 있을 때 사용합니다
<br>


## 📂 Project Foldering Convention

```bash
├── ci_scripts
│   ├── .swiftlint
├── Application
│   ├── AppDelegate
│   ├── SceneDelegate
│   ├── LaunchScreen
├── Global
│   ├── Extension
│   ├── Literals
│   │   ├── Font
│   ├── Resources
│   │   ├── Assets
│   │   ├── Lottie Animation
│   ├── Utility
│   │   ├── Info.plist
│   │   ├── Config.xcconfig
├── Domain
├── Data
│   ├── DTO
│   ├── Router
│   ├── Base
├── Presentation
│   ├── Scene1
│   │   ├── View
│   │   │   ├── Cell
│   │   ├── ViewController
│   │   ├── ViewModel
```
<br>

## [🔫 Troubleshooting](https://massive-maple-b53.notion.site/94a2aec6b988473e9ecb9322a28ade7d?pvs=4)

<br>

## 📸 우리의 사진
![Untitled](https://github.com/user-attachments/assets/7dccc850-c3e3-4d4a-9ce1-7dd947ad68e1)

<br>

