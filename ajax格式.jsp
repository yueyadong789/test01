<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/js/jquery-1.11.3.min.js" type="text/javascript"></script>
<script type="text/javascript">
	$(function () {
        loadTableData();
    });
	//加载表格数据
	function loadTableData() {
        //请求服务器，查询所有的人员信息
        $.ajax({
            method:"POST",
            url:"/day04_js_1/person",
            data:{"method":"plist"},
            dataType:"json",
            success:function (data) {
                //1、获取表格对象
                var t2 = $("#t2");
                //2、遍历数组，每遍历一个人，生成一个<tr>，追加到表格末尾
                $(data).each(function (index) {
                    var str = '<tr><td><input type="checkbox" name="cc" value="'+this.pid+'"/></td><td>'+this.pid+'</td><td>'+this.pname+'</td><td><input type="button" value="查看详情" onclick="viewPerson('+this.pid+')"/></td></tr>';
                    t2.append(str);
                });
            }
        });
    }
	//查询详情
	function viewPerson(pid) {
		$.ajax({
			method:"POST",
			url:"/day04_js_1/person",
			data:{"method":"searchPersonByPid","pid":pid},
			dataType:"json",
			success:function (data) {
				//data---->Person对象
				$("#pid").val(data.pid);
                $("#pname").val(data.pname);
                $("#sex").val(data.sex);
                $("#age").val(data.age);
            }
		});
    }
    
    //修改某个人员信息
	function editPerson() {
		//1、从输入框获取人员信息
		var pid = $("#pid").val();
        var pname = $("#pname").val();
        var sex = $("#sex").val();
        var age = $("#age").val();
		//2、发送ajax请求，修改数据
		$.ajax({
			method:"POST",
			url:"/day04_js_1/person",
			data:{"method":"modifyPerson","pid":pid,"pname":pname,"sex":sex,"age":age},
			success:function (data) {
				if(data=="1"){
				    alert("修改成功");
				    //初始化表格
					$("#t2").html("<tr><th></th><th>ID</th><th>名字</th><th>操作</th></tr>");
                    loadTableData();
				}
            }
		});
    }

    //添加人员信息
	function addPerson() {
		//1、准备数据
        var pname = $("#pname").val();
        var sex = $("#sex").val();
        var age = $("#age").val();
		//2、发送ajax请求，添加一条数据
		$.ajax({
			method:"POST",
			url:"/day04_js_1/person",
			data:{"method":"addPerson","pname":pname,"sex":sex,"age":age},
			success:function (data) {
				if(data=="1"){
				    alert("添加成功");
                    //初始化表格
                    $("#t2").html("<tr><th></th><th>ID</th><th>名字</th><th>操作</th></tr>");
                    loadTableData();
				}
            }
		});
    }
    
    //删除选中
	function deletePlist() {
		//1、拼接待删除人员的pid     pid1,pid2,pid3
		//1.1、获取所有被选中的复选框
		var arr = $("input[type='checkbox'][name='cc']:checked");
		//1.2、遍历复选框，拼接每个复选框的value值
		var pids = "";
		arr.each(function (index) {
			//this -----> 复选框JS对象
			pids+=this.value;
			if(index!=arr.size()-1){
                pids+=",";
			}
        });
		//alert(pids);
		//2、发送ajax请求，删除这些人员
		$.ajax({
			method:"POST",
			url:"/day04_js_1/person",
			data:{"method":"deletePlist","pids":pids},
			success:function (data) {
				alert("成功删除了"+data+"条数据");
                //初始化表格
                $("#t2").html("<tr><th></th><th>ID</th><th>名字</th><th>操作</th></tr>");
                loadTableData();
            }
		});
    }
</script>
</head>
<body>
	<table id="t1" border="1" width="100%">
		<tr>
			<td>人员ID</td>
			<td><input type="text" id="pid" value=""/></td>
		</tr>
		<tr>
			<td>姓名</td>
			<td><input type="text" id="pname" value=""/></td>
		</tr>
		<tr>
			<td>性别</td>
			<td><input type="text" id="sex" value=""/></td>
		</tr>
		<tr>
			<td>年龄</td>
			<td><input type="text" id="age" value=""/></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input type="button" value="修改" onclick="editPerson()"/>
				<input type="button" value="添加" onclick="addPerson()"/>
			</td>
		</tr>
	</table>
	<input type="button" value="删除选中" onclick="deletePlist()"/>
	<hr/>
	<table id="t2" border="1" width="100%">
		<tr>
			<th></th>
			<th>ID</th>
			<th>名字</th>
			<th>操作</th>
		</tr>
		<%--<tr>
			<td>1</td>
			<td>张三</td>
			<td>
				<input type="button" value="查看详情" onclick="viewPerson(1)"/>
			</td>
		</tr>--%>
	</table>
</body>
</html>