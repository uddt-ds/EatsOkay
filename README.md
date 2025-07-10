<!-- 상단 헤더 -->
<p align="center">
  <img src="https://github.com/user-attachments/assets/9963140e-e04a-434e-90ff-3cb288f5b964" 
       alt="App Icon" width="100" />
</p>

<h1 align="center">
  EatsOkay
  <p align="center">
  <img src="https://img.shields.io/badge/프로젝트 기간-2025.05.29 ~ -fab2ac?style=flat&logo=&logoColor=white" alt="프로젝트 기간" />
  <img src="https://img.shields.io/badge/release-v1.3.0-4fc08d?style=flat&logo=google-chrome&logoColor=white" alt="릴리즈 버전" />
</p>
</h1>

## 📚 목차
1. [프로젝트 소개](#project-intro)
2. [팀소개](#team-intro)
3. [주요기능](#features)
4. [개발기간](#duration)
5. [기술스택](#tech-stack)
6. [기술적 의사결정] (#tech-decision)
7. [DataFlow](#DataFlow)
8. [샘플이미지](#sample-images)

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
| 이다성 | 리더 | • Home 화면 구현 <br>• 사진 상세보기 화면(UI) 구현 <br>• SituationDataManager 구현 <br>• Codebase DesignSystem 구현 |
| 이찬호 | 부리더 | • 지역선택 화면 구현 <br>• 사진 상세보기 화면(로직) 구현 <br>• AddressManager 구현 <br>• LocationManager 구현 <br>• AttributedStringManager 구현 <br>• 공통 UIComponent(CustomButton) 구현 <br>• 공통 UIComponent(CustsomLocationAlert) 구현  <br>• Tuist 도입 |
| 김기태 | 팀원 | • 스플래시 화면 구현 <br>• 온보딩 화면 구현 <br>• 요약 화면(위치) 구현  <br>• NetworkManager 구현 <br>• UserDefaultsManager 구현 |
| 박혜민 | 팀원 | • 상세화면 지도 구현(Google Maps iOS SDK 활용) <br>• 요약 화면(매장 특징) 구현 <br>• 와이어프레임, 유저플로우 작성 |
| 허성필 | 팀원 | • 상세화면 리스트 구현(NetworkManger 활용) <br>• 요약 화면(매장 정보) 구현 <br>• Google Place API 호출 캐싱 기능 구현 <br>• 외부 웹페이지 표시 기능 구현 <br>• 공통 UIComponent(CustomSeparator) 구현 |

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
  - 리스트 선택시 요약 화면 연결
- 요약 화면
  - 매장 추가 사진 확인
  - 사진 클릭시 사진 상세보기 화면 연결
  - 매장 특징 확인
  - 매장 위치 및 주소 확인
  - 전화하기 버튼을 이용한 전화하기
  - 웹에서 보기 선택시 웹페이지 연결
- 사진 상세보기 화면
  - 상단에 선택한 사진 표시
  - 하단에 미리보기를 통한 추가 사진 표시
- 웹페이지 화면
  - 상세정보 확인

<a id="duration"></a>
## 📅 개발기간
| 버전 | 기간 | 주요 변경 내용 |
| --- | --- | --- |
| V1.0 | 2025.05.29(목) ~ 06.19(목) | MVP 기능 구현 |
| V1.1.0 | 2025.06.20(금) ~ 06.25(수) | [버그수정] <br> • DetailView Map 버튼 색상,Throttle, Alert 수정 <br> • NetworkManger LocationRestriction 적용 <br> • LocationView 전처리문을 이용한 Error 분기처리 <br> • HomeView 그림자 수정 <br> • DetailView List LocationRestriction 적용 <br> • HomeView 사진 여백 수정 <br> • LocationManager 캐시문제 |
| V1.2.0 | 2025.06.25(수) ~ 06.27(금) | [버그수정] <br> • DetailView Duplicate item error 수정 <br><br> [기능개선] <br> • DetailView 지도 panning 동작에 따른 현위치에서 검색 버튼 표시여부 분기처리 <br> • DetailVIew UI 수정(네이게이션 바, 현위치에서 검색 버튼, 지도, 지도 마커) <br> • DetailView에서 현위치 사용시 지도내 현재위치 아이콘 표시 <br> • HomeView내 해시태그 관리 로직 개선 <br> • HomeVIew UI수정(위치 수정 버튼) <br><br> [성능개선] <br> • 성능개선을 위한 화면전환 방법 변경(온보딩, LocationVIew) <br><br> [프로젝트개선] <br> • 프로젝트 관리를 위한 Tuist 도입 |
| V1.3.0 | 2025.06.27(금) ~ 07.5(토) | [기능 추가] <br> • StoreSummaryView 구현 <br> • DetailPhotsView 구현 <br><br> [기능개선] <br> • DetailView toastMessage 표시 <br> • LocationView 피커뷰 지역 확장 및 뒤로가기 버튼 추가 <br> • HomeView 시인성 향상을 위한 UI 수정 <br> • 온보딩 애니메이션 효과 적용 및 이미지 변경 <br><br> [성능개선] <br> • HomeView 누락된 접근제어자 수정 <br><br> [프로젝트 관리] <br> • Google Place, Google Maps iOS SDk API 키 변경 <br> • Asset 구조 정리 |





<a id="tech-stack"></a>
## ⚙️ 기술스택

### 개발환경

| 구분 | 비고 |
|-------------|--------------------------------------|
| Swift 5 | iOS 앱 개발을 위한 프로그래밍 언어 |
| Xcode 16.2 | iOS 앱 개발을 위한 공식 IDE |
| iOS 16.6 | Target OS 버전 |
| [Tuist 4.50.2](https://github.com/tuist/tuist) | 타깃, 스킴, 의존성, 모듈 구성 등을 코드로 관리하고 <br>프로젝트 설정을 자동화하는 CLI 기반 프로젝트 생성 도구 |

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
| [Moya 15.0.3](https://github.com/Moya/Moya) | Alamofire 기반의 네트워킹 추상화 레이어로, API 요청을 열거형 기반으로 관리 가능한 라이브러리 |

### 기타 라이브러리

| 구분 | 비고 |
|--------------------------------|---------------------------------------------------------------------|
| [RxSwift 6.9.0](https://github.com/ReactiveX/RxSwift) | 반응형 프로그래밍을 위한 라이브러리 |
| [RxDataSources 5.0.2](https://github.com/RxSwiftCommunity/RxDataSources) | 테이블·컬렉션 뷰를 Rx로 구성할 수 있도록 돕는 라이브러리로 섹션, 애니메이션 바인딩 등을 지원하는 라이브러리 |
| [Kingfisher 8.3.2](https://github.com/onevcat/Kingfisher) | 이미지를 다운로드하고 캐싱하는 데 사용되는 라이브러리 |

<a id="tech-decision"></a>
## 🧠 기술적 의사결정

- RxSwift 선택
  - 사용자 입력과 UI 상태 변경을 반응형으로 처리함으로써 비동기 흐름을 직관적으로 관리.

- ReactorKit 아키텍처 선택
  - View와 Reactor 간 단방향 데이터 흐름을 통해 상태 관리 일관성을 확보.

- Google Maps SDK 사용
  - 국내 사용자는 카카오와 네이버 지도가 익숙하지만, 해당 플랫폼에서는 업체 사진 정보를 API로 제공하지 않아 기능 제약이 있음.
  - Google Place API는 제한적이나마 사진 데이터를 제공하므로 이를 기반으로 매장 상세 정보를 시각적으로 표현 가능.
  - 지도 기능도 Google Maps SDK로 통일하여 일관성 및 연계성 확보.

- Google Place API 사진 요청 캐시 처리
  - Google Place API는 사진 요청 시 한 쿼리에 하나의 사진만 응답이 가능해, 중복 요청을 줄이기 위해 딕셔너리 기반 캐시 기능을 구현.

- Moya 도입
  - API 요청을 열거형으로 관리하여 명시성과 모듈화 가능성을 높이고, 테스트 작성이 용이한 구조를 마련.

- Tuist 도입
  - 협업 시 프로젝트 파일의 불필요한 충동 방지 및 프로젝트 파일 구조및 관리 용이성 확보.

<a id="DataFlow"></a>
## 🔄 DataFlow

<h4 align="left">온보딩화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/aa84c678-97d8-4736-9371-b55d4c3ca624" width="95%">
</p>
<hr>

<h4 align="left">지역설정화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/77b4cd70-3453-421d-b07e-86705aa64528" width="95%">
</p>
<hr>


<h4 align="left">메인 화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/b31893e3-7202-44f5-8847-8c0a3b011b40" width="95%">
</p>
<hr>

<h4 align="left">상세 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/d0f58f07-bdd2-435b-a2c1-74a5cd4f45c0" width="95%">
</p>
<hr>

<h4 align="left">요약 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/019cfec6-cfbe-4c46-9553-8b5f89ff90c4" width="95%">
</p>
<hr>

<h4 align="left">사진 상세보기 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/fa7e91a4-dcf1-4b7c-b5fe-699bdcaa77ad" width="95%">
</p>


<a id="sample-images"></a>
## 🖼️ 샘플이미지

<h4 align="left">스플래시화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/6de49907-5901-4dc8-ae01-696495ad60b3" alt="스플래시뷰" width="30%">
</p>
<hr>

<h4 align="left">온보딩화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/ddbe23d8-3668-4d4b-ba97-4c65a6e39205" width="30%">
  <img src="https://github.com/user-attachments/assets/e8a8ac5f-f440-4499-a749-e2002622ae84" width="30%">
  <img src="https://github.com/user-attachments/assets/aa94ad11-46c7-4392-a0bd-033a99896cf2" width="30%">
</p>
<hr>

<h4 align="left">지역설정화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/67d32304-b0ea-4734-b784-1da2eba4e645" width="30%">
</p>
<hr>


<h4 align="left">메인 화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/c86822c0-4723-4195-b196-a686b42f871c" width="30%">
  <img src="https://github.com/user-attachments/assets/be7d3a62-75d8-45d5-8fde-4ed7bd831c22" width="30%">
</p>
<hr>

<h4 align="left">상세 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/c09cf57f-69df-41fb-9b6f-c2aeaa6ef1c8" width="30%">
    <img src="https://github.com/user-attachments/assets/9699c355-4b16-48a8-817e-077a62a8b2cb" width="30%">
</p>
<hr>

<h4 align="left">요약 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/cee77fe2-bafd-4462-991d-3e2e9536903a" width="30%">
    <img src="https://github.com/user-attachments/assets/4ea88f84-bc0e-4002-b096-7a6b80e0a348" width="30%">
    <img src="https://github.com/user-attachments/assets/b8489717-77e8-4767-a9f1-c94ccc1c319d" width="30%">
</p>
<hr>

<h4 align="left">사진 상세보기 화면</h4>
<p align="left">
    <img src="https://github.com/user-attachments/assets/7279931e-08e6-4ab1-b2a4-8f1e1250615c" width="30%">
</p>
<hr>

<h4 align="left">웹페이지 화면</h4>
<p align="left">
  <img src="https://github.com/user-attachments/assets/9a8be269-275f-4b2b-bb44-855101a3e50d" width="30%">
</p>