<img width="256" height="256" alt="Image" src="https://github.com/user-attachments/assets/ef66efbb-b422-49f8-bc96-640a14ce9713" />

# 프로젝트 개요

### 1. 프로젝트 명

- DutyTable – 일정·당번·역할 관리 캘린더 서비스

### 2. 프로젝트 목적

- 일반 캘린더로 관리하기 어려운 당번표, 반복 역할, 특정 날짜 제외 일정, 감정 태그 기반 일정 관리를누구나 쉽게 만들고 공유할 수 있는 고도화된 일정 관리 채팅 서비스 제공

### 3. 대상 사용자

- 정기적인 업무 분담 또는 복잡한 반복 일정을 관리하는 사용자 그룹
- 여러 명이 돌아가며 업무를 분담하는 직장인/팀원
- 본인이 담당하는 일정을 잊지 않고 관리하려는 사용자
- 주말/공휴일 등 휴무일을 제외하고 일정을 설정하려는 사용자

### 4. 개발 기간
- 2025.11.24 ~ 2026.01.13

# 사용 기술
    Language/UI:
        - Dart
        - Flutter
    
    API:
        - RESTful API

    Architecture:
        - MVVM
    
    Database:
        - Supabase(RESTful API)
    
    Library:
        - cupertino_icons
        - google_sign_in
        - sign_in_with_apple
        - syncfusion_flutter_calendar
        - syncfusion_flutter_core
        - flutter_naver_map
        - timezone
        - provider
        - go_router
        - supabase_flutter
        - intl
        - url_launcher
        - image_picker
        - fluttertoast
        - shared_preferences
        - flutter_dotenv
        - dio
        - flutter_native_splash
        - firebase_messaging
        - firebase_core
        - flutter_local_notifications
        - googleapis
        - googleapis_auth
        - http
        - app_links
        - share_plus
        - home_widget
        - dart_pubspec_licenses



# 주요 기능
- **Firebase Auth 를 사용한 회원가입 및 로그인**
    - 구글
    - 애플 - IOS 에서만 적용됨
    - 회원가입 시 클라우드에도 일정 저장 지원
- **공유캘린더**
    - 공유 캘린더 목록
    - 공유 캘린더 추가
        - 캘린더 사진
        - 캘린더 이름
        - 캘린더 멤버 추가(초대)
        - 캘린더 설명
    - 공유 캘린더 삭제
- **내 캘린더**
    - 나만의 캘린더
- **캘린더 탭**
    - 캘린더 화면에 일정 표시(색상 구분 가능)
    - 일정 추가
    - 내 일정 불러오기 가능
- **리스트 탭**
    - 카테고리 별 일정 표시
    - 일정 완료 체크
    - 태그 별 필터링(날짜, 카테고리)
- **채팅 탭**
    - 같은 캘린더를 공유하는 사용자끼리 채팅 가능
- **일정 추가하기**
    - 감정 태그
    - 특정 날짜 제외 버튼 기능(공휴일, 주말, 휴일, 평일 등)
    - 일정 상태 (to do / done)
    - 날짜 시간 지정
    - 알림 설정(알림 x, 일정 하루전, 1시간 전 등)
    - 주소 추가 + 맵에 표시
- **일정 상세 스크린**
    - 일정 상세 정보 조회
    - 삭제/수정/완료 체크
- **프로필 스크린**
    - 회원 탈퇴
    - 라이트 모드 / 다크 모드 / 시스템 모드
    - 구글 캘린더 연동 선택
    - 로그아웃
    - 프로필 수정
- **Push 알림**
    - 알림 on/off 선택

# 화면
| 로그인 화면 | 회원가입 화면 | 홈 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/06fb2328-2fee-4b05-a02a-1432f6a18113" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/68159564-b393-4371-a0d0-e3d9cff3989c" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/1c29bc68-13f1-4254-adb3-07c85ee46649" /> |

| 캘린더 추가 화면 | 공유 캘린더 화면 | 공유 캘린더(목록) 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/f579dd3d-cba9-4290-96a3-42e1fa98e7cf" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/3df52226-d308-462c-a6d9-875d46fc82b6" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/2b1f0f9e-5905-48c8-9d47-42433eee15db" /> |

| 공유 캘린더(채팅) 화면 | 공유 캘린더(내 일정 불러오기) 화면 | 공유 캘린더(목록(내 일정 불러오기)) 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/84fa3f6d-1b30-4cd4-b510-0ec8035a18cd" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/d7ef0acd-f3e5-43a8-a3ed-4653ddad3781" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/04f0b25d-0350-4ba6-967d-8ddf57262e16" /> |

| 일정 추가 화면 | 캘린더 설정 화면 | 캘린더 수정 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/02f9e94a-cfb7-45c4-847f-59286d299737" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/2ba3fd4a-38b7-440a-9a12-b97335016eb6" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/4702cab9-f192-49d8-a789-2fe42003f8f4" /> |

| 내 캘린더 화면 | 내 캘린더(목록) 화면 | 내 캘린더(채팅) 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/c0737045-5f62-4099-bb0f-7d1bf69adcf4" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/77935c55-3984-4431-8c5e-d22bf4d88995" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/7403c071-0e23-4437-9562-c14094dafdd5" /> |

| 내 캘린더(모든 일정 불러오기) 화면 | 내 캘린더(목록(모든 일정 불러오기)) 화면 | 프로필 화면 |
| --- | --- | --- |
| <img width="250" alt="Image" src="https://github.com/user-attachments/assets/7a36e445-ecc7-46d4-bbee-0814c9785964" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/d0b751a3-bbdf-4ce7-9df3-1c38e061f05c" /> | <img width="250" alt="Image" src="https://github.com/user-attachments/assets/7022850f-710c-4066-8c60-d89113b129e8" /> |

# 팀원 소개

| 팀장 | 부팀장 | 팀원 | 팀원 | 팀원 |
| :-: | :--: | :-: | :-: | :-: |
| <img width="140" height="140" alt="Image" src="https://github.com/user-attachments/assets/f464a2cf-2600-4237-a05c-9d5e4284ed56" /> | <img width="140" height="140" alt="Image" src="https://github.com/user-attachments/assets/4dd0121b-6250-4fb9-bf7f-b92e24839136" /> |  <img width="140" height="140" alt="Image" src="https://github.com/user-attachments/assets/71350d4d-8633-4860-ad8d-26dd82245165" /> | <img width="140" height="140" alt="Image" src="https://github.com/user-attachments/assets/0d842ed1-581f-49ba-91e9-78a67d50b768" /> | <img width="140" height="140" alt="Image" src="https://github.com/user-attachments/assets/0c06118c-6b31-4d91-93f1-ec88ae1344b6" /> |
| [권영진](https://github.com/0jhin) | [오민석](https://github.com/oh930428) | [서연우](https://github.com/123-art-ctrl) | [이가은](https://github.com/ggaeunnn) | [권양하](https://github.com/didgk325)

## License & Open Source

Copyright (c) 2026 0jhin (LIKELION Android BOOTCAMP 5th)

This project is licensed under the [MIT License](LICENSE).

### Open Source Licenses
This application is developed using Flutter and various open-source libraries. We strictly adhere to the licensing terms of all third-party software used.

- **Third-party Licenses:** You can view the full list of open-source licenses used in this project within the app:
  - **프로필 > 오픈소스** 메뉴에서 확인 가능합니다.

Built with the help of [flutter_oss_licenses](https://pub.dev/packages/flutter_oss_licenses).
