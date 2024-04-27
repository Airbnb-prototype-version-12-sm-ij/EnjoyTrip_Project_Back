<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>


<style>
    div#writeForm {
        width: 80%;
        position: absolute;
        top: 10%;
    }
</style>


<%@ include file="../common/loginnav.jsp" %> <!-- 로그인 페이지 조각 추가 -->


<div id="writeForm" class="row justify-content-center">
    <div class="col-lg-8 col-md-10 col-sm-12">
        <h2 class="my-3 py-3 shadow-sm bg-light text-center">
            <mark class="sky">글쓰기</mark>
        </h2>
    </div>
    <div class="col-lg-8 col-md-10 col-sm-12">
        <form id="form-register" method="POST" enctype="multipart/form-data" action="/posting/write">
            <input type="hidden" name="pgno" value="1">
            <input type="hidden" name="key" value="">
            <input type="hidden" name="word" value="">
            <div class="mb-3">

                <label for="search-sido" class="sido-label">시도 : </label>
                <select id="search-sido" class="sido-form-select" name="sidoCode" aria-label="Default select example">
                    <option value="0" selected>검색 할 시, 도 선택</option>
                    <option value="1">서울</option>
                    <option value="2">인천</option>
                    <option value="3">대전</option>
                    <option value="4">대구</option>
                    <option value="5">광주</option>
                    <option value="6">부산</option>
                    <option value="7">울산</option>
                    <option value="8">세종특별자치시</option>
                    <option value="31">경기도</option>
                    <option value="32">강원도</option>
                    <option value="33">충청북도</option>
                    <option value="34">충청남도</option>
                    <option value="35">경상북도</option>
                    <option value="36">경상남도</option>
                    <option value="37">전라북도</option>
                    <option value="38">전라남도</option>
                    <option value="39">제주도</option>
                </select>


                <div>
                    <label for="search-gugun" class="gugun-label">구군 : </label>
                    <select id="search-gugun" name="gugunCode" class="gugun-form-select"
                            aria-label="Default select example">
                        <option value="0" selected>검색 할 구, 군 선택</option>
                    </select>
                </div>

                <label for="subject" class="form-label">제목 : </label>
                <input
                        type="text"
                        class="form-control"
                        id="subject"
                        name="title"
                        placeholder="제목..."
                />
            </div>
            <div class="mb-3">
                <label for="content" class="form-label">내용 : </label>
                <textarea class="form-control" id="content" name="content" rows="7"></textarea>
            </div>
            <div class="mb-3">
                <label for="upfile" class="form-label">파일:</label>
                <input type="file" class="form-control border" id="upfile" name="upfile" multiple="multiple">
            </div>

            <div class="col-auto text-center">
                <button type="submit" id="btn-register" class="btn btn-outline-primary mb-3">
                    글작성
                </button>
                <button type="button" id="btn-list" class="btn btn-outline-danger mb-3">
                    목록으로이동...
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('search-sido').addEventListener('change', function () {
        var selectedValue = this.value;
        if (selectedValue) {
            fetch('/posting/getGugun/' + selectedValue)
                .then(response => response.json())
                .then(data => {
                    var select = document.getElementById('search-gugun');
                    // 기존의 옵션을 모두 제거합니다.
                    select.innerHTML = '';
                    // 새로운 옵션을 추가합니다.
                    data.forEach(function (item) {
                        var option = document.createElement('option');
                        option.value = item.gugunCode;
                        option.text = item.gugunName;
                        select.add(option);
                    });
                })
                .catch(error => console.error('Error:', error));
        }
    });
</script>

</body>
</html>