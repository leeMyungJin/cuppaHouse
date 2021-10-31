<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
 <form action="https://175.126.37.210/file/uploadFile" method="post" enctype="multipart/form-data">
        <input type="file" name="file" id="file">
        <input type="text" name="filePath" id="filePath" value= "">
        <input type="text" name="fileName" id="fileName" value = "">
        <input type="submit" name="submit" value="Upload File">
    </form>
</body>
<form action="https://175.126.37.210/file/deleteFile" method="post" enctype="multipart/form-data">
        <input type="file" name="file" id="file">
        <input type="text" name="filePath" id="filePath" value= "">
        <input type="text" name="fileName" id="fileName" value = "">
        <input type="submit" name="submit" value="Delete File">
    </form>
</body>
</html>
