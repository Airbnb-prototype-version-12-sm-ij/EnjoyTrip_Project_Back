<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.ssafy.enjoytrip.domain.member.entity.MemberEntity" %>

<%
    MemberEntity loginMember = (MemberEntity)request.getSession().getAttribute("memberDto");
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>

<style>
    /* 추가 : 원격 폰트 불러오는 리스트 */
    /* [1] 카페24슈퍼매직 */
    @font-face {
        font-family: "Cafe24Supermagic-Bold-v1.0";
        src: url("https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2307-2@1.0/Cafe24Supermagic-Bold-v1.0.woff2") format("woff2");
        font-weight: 700;
        font-style: normal;
    }

    /* [2] 국민연금체 */
    @font-face {
        font-family: "NPSfontBold";
        src: url("https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2310@1.0/NPSfontBold.woff2") format("woff2");
        font-weight: 700;
        font-style: normal;
    }

    /* [3] 마포배낭여행*/
    @font-face {
        font-family: "MapoBackpacking";
        src: url("https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2001@1.1/MapoBackpackingA.woff") format("woff");
        font-weight: normal;
        font-style: normal;
    }

    /* 원격 폰트 리스트 종료 */
    body {
        /* 배경 이미지 추가 및 폰트 적용 */
        background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
        url("../assets/img/background1.jpg");
        background-size: cover;
        background-repeat: no-repeat;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0;
        font-family: "Cafe24Supermagic-Bold-v1.0";
        /* 좌우 여백 설정 */
        /* 아래쪽으로만 늘어나는 높이 조정 */
        min-height: 100vh;
        /* 위쪽 여백 설정 */
        /* 여기에 적절한 값을 넣어줍니다. */
        padding: 10% 20px 0;
    }

    .container {
        /* .container 추가 : 주요 UI(검색 등) 배경에 흰색 네모 박스 추가 */
        background-color: rgba(255, 255, 255, 0.8);
        padding: 20px;
        border-radius: 4px;
    }

    .scrollable {
        max-height: 600px;
        overflow-y: auto;
    }

    .custom-btn {
        text-decoration: none; /* 밑줄 제거 */
        color: #999; /* 텍스트 색상 설정 */
    }

    /* 추가 : 네비게이션 바 배경색 변경 */
    .navbar {
        background-color: #05b7ee62;
    }

    .navbar-nav > li {
        padding-left: 15px;
    }

    .btn-primary {
        /* .btn-primary 추가 : 기본 버튼의 색을 변경 */
        background-color: #f79e3e;
        border-color: #f79e3e;
        color: black;
    }

    .btn-primary:hover {
        /* .btn-primary:hover 추가 : 기본 버튼에 마우스를 올렸을 때 변하는 색을 위에서 변경한 색에 맞게 변경 */
        background-color: #ffbf7a;
        border-color: #ffbf7a;
        color: black;
    }

    .row {
        margin-top: 20px; /* 검색 바 아래 여백을 줍니다. */
    }

    .navbar {
        /* .navbar 추가 : UI 위치가 박살나서 추가, 챗GPT가 썼음 */
        position: absolute; /* navbar를 위치 고정으로 설정합니다. */
        top: 0; /* 화면 맨 위에 위치하도록 합니다. */
        left: 0; /* 화면 맨 왼쪽에 위치하도록 합니다. */
        right: 0; /* 화면 맨 오른쪽까지 넓이를 설정합니다. */
    }

    /* .modal-header 추가 : modal-header 색 조정 */
    .modal-header {
        background-color: #05b7ee62;
        color: #ffffff;
    }

    .navbar-toggler {
        width: 60px; /* 원하는 너비로 설정 */
        height: 48px; /* 원하는 높이로 설정 */
    }

    footer {
        position: fixed;
        bottom: 0;
        width: 100%;
        background-color: rgba(255, 255, 255, 0.8); /* 풋터 배경색 설정 */
        padding: 10px 0; /* 풋터 안의 내용 여백 설정 */
        text-align: center; /* 풋터 내용 가운데 정렬 */
    }

    #map-modalfooter {
        max-height: calc(70vh - 300px); /* 모달 창 높이에서 헤더와 푸터 높이를 제외한 값 */
        overflow-y: auto;
    }

    th {
        text-align: center;
    }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css"
/>
<script
        type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c9c4977a5d4ddc19f25aa9b22c1e264a&libraries=services"
></script>


<ul class="navbar-nav me-lg-5 d-flexb">
    <%
        if (loginMember == null) {
    %>
    <li class="nav-item p-1">
        <button
                id="showLoginModalBtn"
                class="btn btn-primary"
                type="button"
                data-bs-toggle="modal"
                data-bs-target="#loginModal"
        >
            Login
        </button>
    </li>
    <li class="nav-item p-1">
        <button
                id="showSignupModalBtn"
                class="btn btn-primary"
                type="button"
                data-bs-toggle="modal"
                data-bs-target="#signupModal"
        >
            Join
        </button>
    </li>
    <%} else {%>
    <li class="nav-item d-flex align-items-center pe-lg-3">
        <div id="user-name"><%=loginMember.getUserName()%> &#x1F60A;</div>
    </li>
    <li class="nav-item p-1">
        <button id="logoutBtn" class="btn btn-primary">Logout</button>
    </li>
    <%if (loginMember.getGrade().equals("admin")) { %>
    <li class="nav-item p-1">
        <button
                id="showMMModalBtn"
                class="btn btn-primary"
                type="button"
                data-bs-toggle="modal"
                data-bs-target="#MMModal"
        >
            Manage Member
        </button>
    </li>
    <%} %>
    <li class="nav-item p-1">
        <button
                id="showMyPageModalBtn"
                class="btn btn-primary"
                type="button"
                data-bs-toggle="modal"
                data-bs-target="#MyPageModal"
        >
            My Page
        </button>
    </li>
    <%} %>
</ul>
