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


<!-- 네비게이션 바 -->
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container-fluid">
        <!-- 로고로 바꾸기 -->
        <div class="navbar-brand ms-5 ps-5">
            <img src="../assets/img/logo.png" width="96px" alt="로고"/>
        </div>
        <div class="d-flex flex-column-reverse align-items-lg-center">
            <div class="collapse navbar-collapse mt-lg-0" id="navbarSupportedContent">
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
            </div>
            <button
                    class="navbar-toggler"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent"
                    aria-expanded="false"
                    aria-label="Toggle navigation"
            >
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
    </div>
</nav>


<!-- 로그인 모달 -->
<div
        class="modal fade"
        id="loginModal"
        tabindex="-1"
        aria-labelledby="loginModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="loginModalLabel">로그인</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                <form id="loginForm" method="POST">
                    <input type="hidden" name="action" value="login"/>
                    <div class="mb-3">
                        <label for="loginUserId" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="loginUserId" name="loginUserId" required/>
                        <div id="loginUserIdError" class="invalid-feedback">
                            숫자와 영어 소문자로 3자리 이상 15자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="loginPassword" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="loginPassword" name="loginPassword" required/>
                        <div id="loginPasswordError" class="invalid-feedback">
                            숫자와 영어 소문자로 3자리 이상 15자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="loginBtn">로그인</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            취소
                        </button>
                        <button id="showFindPwdModalBtn" type="button" class="btn btn-link custom-btn">
                            비밀번호 찾기
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 비밀번호 찾기 모달 -->
<div
        class="modal fade"
        id="findPwdModal"
        tabindex="-1"
        aria-labelledby="findPwdModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="findPwdModalLabel">비밀 번호 찾기</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                <form id="findPwdForm">
                    <div class="mb-3">
                        <label for="findPwdUserId" class="form-label">아이디</label>
                        <input type="text" class="findPwdUserId form-control" id="findPwdUserId" required/>
                        <div id="findPwdUserIdError" class="invalid-feedback">
                            숫자와 영어 소문자로 5자리 이상 20자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="findPwdUserName" class="form-label">이름</label>
                        <input type="text" class="findPwdUserName form-control" id="findPwdUserName" required/>
                        <div id="findPwdUserNameError" class="invalid-feedback">
                            한글만 입력 가능합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">새 비밀번호</label>
                        <input
                                type="password"
                                class="form-control"
                                id="findPassword"
                                name="findPassword"
                                required
                        />
                        <div id="findPasswordError" class="invalid-feedback">
                            숫자와 영어 소문자로 5자리 이상 20자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="findConfirmPassword form-control" id="findConfirmPassword"
                               required/>
                        <div id="findConfirmPasswordError" class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="findShowPasswordCheckbox" id="findShowPasswordCheckbox"/>
                        <label class="form-check-label" for="showPasswordCheckbox">비밀번호 보이기</label>
                    </div>

                    <div class="modal-footer">
                        <button id="findMember" type="button" class="btn btn-primary">비밀번호 찾기</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- 마이 페이지 모달 -->
<div
        class="modal fade"
        id="MyPageModal"
        tabindex="-1"
        aria-labelledby="MyPageModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="MyPageModalLabel">마이 페이지</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                <form id="MyPageForm">
                    <!-- my page form이 들어가는 자리 -->

                    <% // 세션 로그인 객체에서 정보를 가져온다
                        String thisName, thisId, thisPassword;
                        if (loginMember != null) {
                            thisName = loginMember.getUserName();
                            thisId = loginMember.getUserId();
                            thisPassword = loginMember.getUserPassword();
                        } else {
                            thisName = "알 수 없음";
                            thisId = "알 수 없음";
                            thisPassword = "알 수 없음";
                        }
                    %>
                    <div class="mb-3">이름: <%=thisName %>
                    </div>
                    <div class="mb-3">아이디: <%=thisId %>
                    </div>
                    <%--<div class="mb-3">비밀번호: <%=thisPassword %>
                    </div>--%>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input
                                type="password"
                                class="form-control"
                                id="newPassword"
                                required
                        />
                        <div id="newPasswordError" class="invalid-feedback">
                            숫자와 영어 소문자로 5자리 이상 20자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmNewPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmNewPassword" required/>
                        <div class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="showNewPasswordCheckbox"/>
                        <label class="form-check-label" for="showNewPasswordCheckbox">비밀번호 보이기</label>
                    </div>
                    <button id="password-chg-btn" class="btn btn-outline-warning">비밀번호 변경</button>
                    <div class="modal-footer">
                        <button id="Membership-Withdrawal-btn" class="btn btn-outline-danger">탈퇴</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 지도 모달 -->
<div
        class="modal fade"
        id="mapModal"
        tabindex="-1"
        aria-labelledby="mapModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="mapModalLabel">지도</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                <div id="map-container" style="height: 650px">
                    <div id="map" style="height: 400px"></div>
                    <div id="map-modalfooter" class="pt-2"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 회원 가입 모달 -->
<div
        class="modal fade"
        id="signupModal"
        tabindex="-1"
        aria-labelledby="signupModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="signupModalLabel">회원 가입</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body">
                <form id="signupForm" method="POST" action="/members/join">
                    <input type="hidden" name="action" value="regist"/>
                    <div class="mb-3">
                        <label for="userId" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="userId" name="userId" required/>
                        <div class="invalid-feedback">
                            숫자와 영어 소문자로 5자리 이상 20자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input
                                type="password"
                                class="form-control"
                                id="password"
                                name="password"
                                required
                        />
                        <div id="passwordError" class="invalid-feedback">
                            숫자와 영어 소문자로 5자리 이상 20자리 이하여야 합니다.
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmPassword" required/>
                        <div class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="showPasswordCheckbox"/>
                        <label class="form-check-label" for="showPasswordCheckbox">비밀번호 보이기</label>
                    </div>
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" id="name" name="name" required/>
                        <div class="invalid-feedback">한글만 입력 가능합니다.</div>
                    </div>
                    <div class="modal-footer">
                        <button id="registBtn" type="submit" class="btn btn-primary">회원 가입</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 회원 조회 모달 -->
<div
        class="modal fade"
        id="MMModal"
        tabindex="-1"
        aria-labelledby="Member-management-ModalLabel"
        aria-hidden="true"
>
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <!-- modal-lg 클래스를 추가하여 큰 모달로 지정 -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="Member-management-ModalLabel">회원 관리</h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                ></button>
            </div>
            <div class="modal-body" style="max-height: 60vh; overflow-y: auto">
                <!-- 스크롤 추가를 위해 스타일 추가 -->
                <div class="row">
                    <div class="col-3 d-flex justify-content-center align-items-center">이름</div>
                    <div class="col-2 d-flex justify-content-center align-items-center">아이디</div>
                    <div class="col-2 d-flex justify-content-center align-items-center">등급</div>
                    <div class="col-2 d-flex justify-content-center align-items-center">가입 일시</div>
                    <div class="col-2 d-flex justify-content-center align-items-center">회원 삭제</div>
                </div>
                <div id="memberList">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            </div>
        </div>
    </div>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
<script src="../assets/js/mypage.js"></script>
<%--<script src="../assets/js/membermanagement.js"></script>--%>
<script src="../assets/js/findpwd.js"></script>
<%--<script src="../assets/js/api.js"></script>--%>
<script src="../assets/js/login.js"></script>
<script src="../assets/js/signup.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


<script>
    // === 로그인, 로그아웃 관련 기능 ===
    // [1] 로그인 버튼 클릭시, controller 이용해 로그인 시행
    // 기존 코드
    if (document.querySelector("#loginBtn") != null) {
        document.querySelector("#loginBtn").addEventListener("click", function (e) {
            e.preventDefault();
            const username = document.getElementById("loginUserId").value;
            const password = document.getElementById("loginPassword").value;

            fetch("/members/login", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userId: username,
                    userPassword: password
                })
            }).then((response) => {
                if (response.ok) {
                    alert('로그인에 성공했습니다.');
                    $("#loginModal").modal("hide");
                    location.reload();
                } else { // 에러가 발생한 경우

                    alert('아이디나 비밀번호를 확인해주세요.');
                }
            });
        });
    }


    // [2] 로그아웃 버튼 클릭시, controller 이용해 로그아웃 시행

    if (document.querySelector("#logoutBtn") != null) {
        document.querySelector("#logoutBtn").addEventListener("click", function () {
            fetch("/members/logout", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then((response) => {
                if (response.ok) {
                    // 로그아웃 성공시
                    alert('로그아웃 되었습니다.');
                    location.reload();
                } else {
                    // Handle errors here
                    console.error('Logout failed');
                }
            });
        });
    }


    // [3] 로그인 이후, 성공여부 표기
    <%
    String msg = (String)request.getSession().getAttribute("loginFail");
    if(msg != null) {%>
    alert("<%=msg%>");
    <%	request.getSession().removeAttribute("loginFail");
    }%>
    // === 회원가입 기능 ===
    if (document.querySelector("#registBtn") != null) {
        document.querySelector("#registBtn").addEventListener("click", function (e) {
            e.preventDefault();
            regist(); // signup.js에 함수화하였음
        });
    }


    // 회원가입 이후, 성공여부 표기
    <% if(request.getAttribute("registSuccess") != null){
        if(request.getAttribute("registSuccess").equals("yes")){
    %>
    alert("가입에 성공했습니다. 로그인해주세요.");
    <%} else {%>
    alert("가입에 실패했습니다. 다시 시도해주세요.");
    <% }
    }%>



    // == 회원관리 모달 기능 ==
    // 모달을 열 때마다 실행될 함수
    if (document.getElementById("showMMModalBtn") != null) {
        document.getElementById("showMMModalBtn").addEventListener("click", function MberModal(e) {
            e.preventDefault();
            fetch("/members/info")
                .then(response => response.json())
                .then(data => {
                    let memberList = document.getElementById("memberList");
                    memberList.innerHTML = "";
                    data.forEach(function (user) {
                        let userNames = user.userName;
                        let userId = user.userId;
                        let grade = user.grade;
                        let registrationDate = user.registrationDate;
                        var row = document.createElement("div");
                        row.classList.add("row");
                        let div1 = document.createElement("div");
                        div1.className = "col-3 d-flex justify-content-center align-items-center";
                        div1.textContent = userNames;

                        let div2 = document.createElement("div");
                        div2.className = "col-2 d-flex justify-content-center align-items-center";
                        div2.textContent = userId;

                        let div3 = document.createElement("div");
                        div3.className = "col-2 d-flex justify-content-center align-items-center";
                        div3.textContent = grade;

                        let div4 = document.createElement("div");
                        div4.className = "col-2 d-flex justify-content-center align-items-center";
                        div4.textContent = registrationDate;

                        let button = document.createElement("button");
                        button.type = "button";
                        button.className = "btn btn-outline-danger user-delete";
                        button.dataset.userId = userId;
                        button.textContent = "X";
                        button.addEventListener('click', () => {
                            fetch("/members/delete", {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify(button.dataset.userId),
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error('Network response was not ok');
                                    }
                                    MberModal(e);
                                })
                                .catch(error => {
                                    console.error('There has been a problem with your fetch operation:', error);
                                    // 여기에서 필요한 추가 작업을 수행하십시오. 예를 들어, 오류 메시지를 표시합니다.
                                });
                        });
                        let div5 = document.createElement("div");
                        div5.className = "col-2 d-flex justify-content-center align-items-center";
                        div5.appendChild(button);

                        row.appendChild(div1);
                        row.appendChild(div2);
                        row.appendChild(div3);
                        row.appendChild(div4);
                        row.appendChild(div5);
                        memberList.appendChild(row);
                    });
                });
        });
    }

    // 회원 관리 모달 닫기 이벤트
    document.getElementById("MMModal").addEventListener("hidden.bs.modal", function () {
        let backdrop = document.querySelector(".modal-backdrop");
        if (backdrop) {
            backdrop.parentNode.removeChild(backdrop);
        }
        document.getElementById("memberList").innerHTML = "";
    });


    // == 마이페이지 비밀번호 바꾸기 기능 ==
    // 현재 새 비밀번호-새 비밀번호 확인 정책 검사가 제대로 되지 않는 문제가 있음...
    // 일단은 새 비밀번호 창의 값을 기반으로 비밀번호를 바꾸도록 하자.
    document.getElementById("password-chg-btn").addEventListener("click", function (e) {
        e.preventDefault();
        let root = "<%=root%>";
        changePassword(root); // mypage.js에 함수화하였음
    });

    // 비밀번호 입력시 보이기
    document.getElementById("newPassword").addEventListener("input", function () {
        const newPassword = this.value;
        validateNewPassword(newPassword);
    });

    // ====== 새 비밀번호 검사 ======
    function validateNewPassword(newPassword) {
        const newpasswordInput = document.getElementById("newPassword");
        let regex = /^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,20}$/;
        if (!regex.test(newPassword)) {
            newpasswordInput.classList.add("is-invalid");
            return false;
        } else {
            newpasswordInput.classList.remove("is-invalid");
            return true;
        }
    }

    // ====== 새 비밀번호 확인 검사 ======
    document.getElementById("confirmNewPassword").addEventListener("input", function () {
        const confirmNewPassword = this.value;
        const newpassword = document.getElementById("newPassword").value;
        validateNewPasswordConfirmation(newpassword, confirmNewPassword);
    });

    // ====== 비밀번호 동일 검사 ======
    function validateNewPasswordConfirmation(newpassword, confirmNewPassword) {
        const confirmNewPasswordInput = document.getElementById("confirmNewPassword");
        if (newpassword !== confirmNewPassword) {
            confirmNewPasswordInput.classList.add("is-invalid");
            return false;
        } else {
            confirmNewPasswordInput.classList.remove("is-invalid");
            return true;
        }
    }

    // == 마이페이지 탈퇴 기능 ==
    document.getElementById("Membership-Withdrawal-btn").addEventListener("click", function (e) {
        e.preventDefault();
        let loginId = "<%=loginMember != null ? loginMember.getUserId() : null%>";
        withdrawal(loginId); // mypage.js에 함수화하였음
    })


</script>