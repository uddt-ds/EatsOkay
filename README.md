<!-- 상단 헤더 -->
<p align="center">
  <img src="https://github.com/uddt-ds/EatsOkay/blob/develop/EatsOkay/App/Assets.xcassets/AppIcon.appiconset/AppIcon.png?raw=true" 
       alt="App Icon" width="100" />
</p>

<h1 align="center">
  EatsOkay
  <p align="center">
  <img src="https://img.shields.io/badge/프로젝트 기간-2025.05.29 ~ -fab2ac?style=flat&logo=&logoColor=white" alt="프로젝트 기간" />
  <img src="https://img.shields.io/badge/release-v1.1.0-4fc08d?style=flat&logo=google-chrome&logoColor=white" alt="릴리즈 버전" />
</p>
</h1>

## 📚 목차
1. [프로젝트 소개](#project-intro)
2. [팀소개](#team-intro)
3. [주요기능](#features)
4. [개발기간](#duration)
5. [기술스택](#tech-stack)
6. [샘플이미지](#sample-images)
7. [실행방법](#how-to-run)

<a id="project-intro"></a>
## 🌤 프로젝트 소개

- EatsOkay는 사용자의 현재 상황에 맞는 외식 장소를 빠르고 직관적으로 추천하는 앱입니다.
- 상황 → 테마 → 지역 및 식당’ 순으로 좁혀가는 단계적 UI 구조를 통해 사용자의 의사결정을 자연스럽게 유도합니다.
- 홈 화면에는 상황 중심 카테고리를 우선 배치하고, 큐레이션 카드와 지도 기반 리스트를 통해 시각적이고 효율적인 탐색 경험을 제공합니다.

<a id="team-intro"></a>
## 👥 팀소개

### 🧑🏻‍💻 코드 개발자

| 이름 | 직책 | 주요 담당 내역 |
| --- | --- | --- |
| 이다성 | 리더 | • Home 화면 구현 <br>• SituationDataManager 구현 <br>• Codebase DesignSystem 구현 |
| 이찬호 | 부리더 | • 지역선택 화면 구현 <br>• AddressManager 구현 <br>• LocationManager 구현 <br>• 공통 UIComponent 구현 |
| 김기태 | 팀원 | • 스플래시 화면 구현 <br>• 온보딩 화면 구현 <br>• NetworkManager 구현 <br>• UserDefaultsManager 구현 |
| 박혜민 | 팀원 | • 상세화면 지도 구현(Google Maps iOS SDK 활용) <br> • 와이어프레임, 유저플로우 작성 |
| 허성필 | 팀원 | • 상세화면 리스트 구현(NetworkManger 활용) <br> • Google Place API 호출 캐싱 기능 구현 <br>• 외부 웹페이지 표시 기능 구현 |

### 🧑🏻‍🎨 디자이너

| 이름 | 직책 | 주요 담당 내역 |
| --- | --- | --- |
| 염지윤 | 팀원(협업디자이너) | • 와이어프레임 <br>• 전체 UI 컨셉 설계 및 시안 제작 <br>• 그래픽 요소 제작 |
| 최윤정 | 팀원(협업디자이너) | • 와이어프레임 <br>• 전체 UI 컨셉 설계 및 시안 제작 <br>• 그래픽 요소 제작 |

<a id="features"></a>
## 🛠 주요기능

- 온보딩
  - 앱 사용 방법 안내
- 지역설정 화면
  - 프리셋을 통한 위치 지정
  - GPS를 이용한 현재 위치 지정
- 홈화면
  - 상황별 추천 리스트 표시
- 상세화면
  - 지도 영역에서의 재검색
  - GPS를 이용한 현재 위치 지정
  - 검색결과 지도에 마커 표시
  - 검색결과 리스트에 표시
  - 검색결과 리스트 정렬
  - 상세정보 확인을 위한 외부 웹페이지 연결
  - 웹페이지 화면

<a id="duration"></a>
## 📅 개발기간
| 버전 | 기간 | 주요 변경 내용 |
| --- | --- | --- |
| V1.0 | 2025.05.29(목) ~ 06.19(목) | MVP 기능 구현 |
| V1.1.0 | 2025.06.20(금) ~ 06.25(수) | [버그수정] <br> • DetailView Map 버튼 색상,Throttle, Alert 수정 <br> • NetworkManger LocationRestriction 적용 <br> • LocationView 전처리문을 이용한 Error 분기처리 <br> • HomeView 그림자 수정 <br> • DetailView List LocationRestriction 적용 <br> • HomeView 사진 여백 수정 <br> • LocationManager 캐시문제 |

<a id="tech-stack"></a>
## ⚙️ 기술스택

### 개발환경

| 구분 | 비고 |
|-------------|--------------------------------------|
| Swift 5 | iOS 앱 개발을 위한 프로그래밍 언어 |
| Xcode 16.2 | iOS 앱 개발을 위한 공식 IDE |
| iOS 16.6 | Target OS 버전 |

### 사용 패턴

| 구분        | 패턴                                | 비고 |
|-------------|-------------------------------------|------|
| 아키텍처 | ReactorKit | • View(View + ViewController)와 Reactor 간의 단방향 데이터 흐름을 구성.<br>• RxSwift 기반의 반응형 바인딩을 통해 사용자 인터랙션과 상태 변화를 처리 |

### UI 구성

| 구분 | 비고 |
|---------|----------------------------------------------------|
| UIKit | iOS 기본 UI 프레임워크 |
| SafariServices | 외부 웹 페이지를 앱 내에서 안전하게 표시할 수 있는 Safari 기반 프레임워크 |
| [SnapKit 5.7.1](https://github.com/SnapKit/SnapKit) | AutoLayout을 간결하게 작성할 수 있는 DSL |
| [GoogleMaps 10.0.0](https://github.com/googlemaps/ios-maps-sdk) | 지도 기반 UI 구현을 위한 Google 공식 SDK 

### 네트워크

| 구분 | 비고 |
|--------|-------------------------------------|
| [Moya 15.0.3](https://github.com/Moya/Moya) | Alamofire 기반의 네트워킹 추상화 레이어로, API 요청을 열거형 기반으로 관리가능한 라이브러리 |

### 기타 라이브러리

| 구분 | 비고 |
|--------------------------------|---------------------------------------------------------------------|
| [RxSwift 6.9.0](https://github.com/ReactiveX/RxSwift) | 반응형 프로그래밍을 위한 라이브러리 |
| [RxDataSources 5.0.2](https://github.com/RxSwiftCommunity/RxDataSources) | 테이블·컬렉션 뷰를 Rx로 구성할 수 있도록 돕는 라이브러리로 섹션, 애니메이션 바인딩 등을 지원하는 라이브러리 |
| [Kingfisher 8.3.2](https://github.com/onevcat/Kingfisher) | 이미지를 다운로드하고 캐싱하는 데 사용되는 라이브러리 |

<a id="sample-images"></a>
## 🖼️ 샘플이미지

<h4 align="left">스플래시화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/6de49907-5901-4dc8-ae01-696495ad60b3" alt="스플래시뷰" width="30%">
</p>
<hr>

<h4 align="left">온보딩화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/da592d73-a605-43a0-9c65-8b3ef4798bb4" width="30%">
  <img src="https://github.com/user-attachments/assets/b006b2a1-c2d8-4ac4-b25f-e34c4ab78edf" width="30%">
  <img src="https://github.com/user-attachments/assets/32c3ce11-fa09-4d6c-8dcc-045c0b4d1174" width="30%">
</p>
<hr>

<h4 align="left">지역설정화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/cee53983-63b1-4c11-9362-cd62596c1b27" width="30%">
</p>
<hr>


<h4 align="left">메인화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/c86822c0-4723-4195-b196-a686b42f871c" width="30%">
</p>
<hr>

<h4 align="left">상세화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/28d05394-5c6b-4155-97e2-ebfd741378b5" width="30%">
</p>

<h4 align="left">웹페이지 화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/a1ccd779-2897-44d1-a173-2c35ef82f862" width="30%">
</p>

<a id="how-to-run"></a>
## ▶️ 실행방법

1. 레포지토리 클론

```bash
git clone https://github.com/uddt-ds/EatsOkay.git

```

2.  APP 폴더에 Config.xcconfig 파일 추가


```bash
GoogleAPIKey = GoogleAPIKey 입력
KakaoAPIKey = KakaoAPIKey 입력

```

3. Config.xcconfig에 API 키 추가
  - API키 보안을 위해 본 레포지토리에는 API키가 포함되어있지 않습니다.