<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&height=250&color=a2dcec&fontColor=363636&text=%EC%95%84%EC%A3%BC%EB%8C%80%20%EC%A0%84%EC%9E%90%EC%B6%9C%EA%B2%B0%20%EB%8F%84%EC%9A%B0%EB%AF%B8%0A" alt="header"/>
</div>

<div align="center">
    Flutter와 스프링을 이용해 전자출결 시간에 맞춰 알림을 울려주는 도우미 앱
    <br><br>
    <a href="https://github.com/bandall/database-project-2023" target="_blank">
        <img src="https://img.shields.io/badge/spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white" alt="Backend Spring Server - View Project">
    </a>
    <br>
    <a href="https://github.com/bandall/database-project-2023" target="_blank">전차 줄결 도우미 백엔드 스프링 서버 보러가기</a>
</div>

<center>

## 🛠️ 기술 스택 🛠️

<div align="center">
    <img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
    <img src="https://img.shields.io/badge/sqlite-003B57?style=for-the-badge&logo=sqlite&logoColor=white">
    <img src="https://img.shields.io/badge/dotenv-ECD53F?style=for-the-badge&logo=dotenv&logoColor=white">
    <img src="https://img.shields.io/badge/android-3DDC84?style=for-the-badge&logo=android&logoColor=white">
    <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
</div>

<br>

## 🧰 개발 도구 🧰

<div align="center">
    <img src="https://img.shields.io/badge/VSCODE-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white">
    <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">
</div>

<br>

## 🎯 개발 동기 🎯

<div align="center">
    <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/89520db0-b834-4bc7-bfa8-e686d549a784" width="500">
</div>

아주대학교는 2020년 1학기부터 학생들의 출결 인증을 위해 스마트폰의 위치기반 블루투스 전자출결 서비스를 도입하였다. 하지만 새로운 시스템은 많은 학생이 실수를 저지르는 원인이 되었다. 한 수업이 끝나고 다음 수업이 바로 시작되는 경우, 학생들은 정확한 수업 시작 시각이 될 때까지 출결 인증을 기다려야 한다. 이에 따라 정시를 기다리다 출결 인증을 잊어버리는 학생들이 많았다. 또한, 이 새로운 시스템에 익숙하지 않은 학기 초에는 출결 인증에 실수가 더 잦게 발생했다. 이러한 문제들로 학생들이 수업에 성실히 출석했음에도 불구하고 인증을 받지 못해, 억울함을 느끼거나 교수님들에게 출결 재인증을 요청해야 하는 등의 번거로움을 초래하였다. 아주대학교 학생 63명을 대상으로 출결 앱을 사용한 뒤로 출결 인증을 잊은 경험이 있는지를 물어보는 설문조사를 진행하였. 설문조사 결과, 출결인증을 잊은 적이 없다고 답변한 학생은 없었다. 57명의 학생은 잊어버린 경험이 있다고 답하였고, 6명의 학생은 잊을 뻔한 경험이 있다고 답하였다.

이 문제를 개선하기 위해 전자 출결 인증 시간에 맞춰 자동으로 알림을 울려주는 알림앱을 개발하기로 하였다.

## 🔰 주요 화면 🔰

</center>

### 1. 회원 가입 및 인증 화면

| 로그인 화면 | 회원가입 화면 | 인증 화면 |
| :-----------: | :-------: | :-------: |
| <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/b7ec1fea-7987-4718-b55b-17cdd8fb0a40"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/b74d8d0d-bfc7-4ea8-bf4c-9a2b93e0810b"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/baa54878-d972-4992-95cf-c7c0eea9439b"> |

- 아주대 이메일로 회원가입을 진행하고, 이메일 인증을 통해 아주대 학생임을 인증합니다.

### 2. 시간표 등록 화면

| 시간표 등록 화면1 | 시간표 등록 화면2 | 시간표 등록 화면3 |
| :-----------: | :-------: | :-------: |
| <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/2752e9b1-113f-44b3-9280-3e647370509f"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/abee504b-d59a-4a1e-a53e-b100e56bc42a"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/231a4a37-06f5-470b-ae48-2c60b08d3bc2"> |

- 에브리타임 시간표 URL을 이용해 시간표를 자동으로 등록함으로써 사용자의 편의성을 높입니다.
- 아주대 전자출결 시스템에 맞춰 1교시는 10분 전, 연강 수업의 경우 정각, 그 외에는 15분 전에 알림을 자동으로 세팅합니다.

### 4. 알림 수정 화면

| 알림 수정 화면 |
| :-----------: |
| <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/2522a7b1-5252-4aa6-9221-b28de90bf177" height="600"> |

- 사용자가 추가적인 알림을 등록할 수 있습니다.
- 이미 설정된 알림을 수정하거나 알림을 끌 수 있습니다.

### 5. 출결 알림 화면

| 출결 알림 화면 |
| :-----------: |
| <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/045a1f05-c0c9-4fbf-a1e8-6989cb2e2452" height="600"> |

- 사용자가 설정한 시간에 맞춰 알림을 울려줍니다.
- 알림을 5분 뒤로 연기할 수 있고, `출석체크 하기` 버튼을 누르면 아주대학교 전자출결 시스템으로 이동합니다.

## 5. 공통 공강 시간표 화면

| 공통 공강 시간표 화면1 | 공통 공강 시간표 화면2 | 공통 공강 시간표 화면3 |
| :----------: | :---------: | :---------: |
| <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/129aa0f2-27bc-4cda-b198-d1975f43885d"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/f399c1ec-3819-4a16-bf28-2bf20e1096e0"> | <img src="https://github.com/bandall/Attendance-Alarm-Flutter/assets/32717522/dfd51ed3-fb67-4013-a9b9-414c1128c56f"> |

- 시간표를 등록한 사용자들의 시간표를 비교해 공통된 공강 시간을 보여줍니다.
- 공강 시간을 클릭하면 해당 시간에 공강이 있는 사용자들의 시간표를 확인할 수 있습니다.
- 이 기능을 통해 팀 프로젝트나 스터디를 진행할 때 편리하게 공강 시간을 찾을 수 있습니다.
