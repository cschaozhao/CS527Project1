<%@page import="com.sun.crypto.provider.RSACipher"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.Calendar"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CS527_Project1_Group11</title>
<script type="text/javascript">
	function validcheck() {
		//获取用户输入的数据
		var sql = document.getElementById("sql").value
		//判断
		if (sql == "") {
			alert("Invalid Query!")
			return false
		} else
			return true
	}
</script>
</head>
<body>
	<table border="0" bgcolor="white" width="100%" align="center" valign="top"
		cellspacing="1px" cellpadding="1px">
		<form action="index.jsp" method="post" name="myquery"
			onsubmit="return validcheck()">
			<tr height="60">
				<td align="left" width="60%">&nbsp; &nbsp; &nbsp; &nbsp; <font
					size="6">DataBase &nbsp; &nbsp; Instacart </font>
				</td>
				<td><input type="radio" name="dbtype" value="Mysql"
					checked="checked" /> Mysql &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
					&nbsp; <input type="radio" name="dbtype" value="Redshift" />
					Redshift</td>
			</tr>

			<tr height="40">
				<td colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <font
					color="cornflowerblue" size="3"> <i><b>Input your
								query in the box:<b></i>
				</font>
				</td>
			</tr>

			<tr height="240">
				<td colspan="2" align="center"><textarea cols="150" rows="15"
						name="sql" id="sql" placeholder="Please input your query here!"></textarea>
				</td>
			</tr>

			<tr height="30">
				<td colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <input
					type="submit" value="Run Query" /> &nbsp; &nbsp; <input
					type="reset" value=" Clear All " />
				</td>
			</tr>
		</form>

		<%
			String url_Mysql = "jdbc:mysql://database-cs527.cybkb98jpdsd.us-east-2.rds.amazonaws.com:3306/instacart";
			String url_Redshift = "jdbc:redshift://redshift-cluster-527.cguppunjr2hy.us-east-2.redshift.amazonaws.com:5439/database-527";

			String username_Mysql = "admin";
			String username_Redshift = "admin";

			String password_Mysql = "sealman1";
			String password_Redshift = "Rutgers1234";

			String url = null;
			String username = null;
			String password = null;

			long time1 = System.currentTimeMillis();

			String DBtype = request.getParameter("dbtype");
			String a = "Mysql";
			if (a.equals(DBtype)) {
				System.out.print("mysql");
				Class.forName("com.mysql.jdbc.Driver");
				url = url_Mysql;
				username = username_Mysql;
				password = password_Mysql;
			} else {
				System.out.print("red");
				Class.forName("com.amazon.redshift.jdbc42.Driver");
				url = url_Redshift;
				username = username_Redshift;
				password = password_Redshift;
			}
				String sql = "";
				sql = request.getParameter("sql");
				if (null == sql || sql.equals("")){
					%>
					<table border="2" bgcolor="white" width="80%" height="300" align="center" cellspacing="1px" cellpadding="1px">
						<tr>
							<td> Welcome! </td>
						</tr>
					</table>
					<%
					}
				else {
					try {
						Connection conn = DriverManager.getConnection(url, username, password);
						// Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
						PreparedStatement stmt=conn.prepareStatement(sql);
						stmt.setMaxRows(50);
						boolean hasResultSet = stmt.execute();
						
						long time2 = System.currentTimeMillis();;						
						long time = (time2 - time1);
					%>
					<tr>
						<td colspan="2" align="right"><font size="" color="olivedrab">Time
								Elapsed:<%=time%> ms
						</font>&nbsp; &nbsp; &nbsp;</td>
					</tr>
					<tr height="25">
						<td colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <font
							color="sandybrown" size="3"> <i><b> Result: <b></i>
						</font><br />
						</td>
					</tr>
				</table>

				<table border="2" bgcolor="white" width="80%" align="center"
					cellspacing="1px" cellpadding="1px">
					<%
						if (hasResultSet) {
								ResultSet rs = stmt.getResultSet();
								ResultSetMetaData rsmd = rs.getMetaData();
								int columnCount = rsmd.getColumnCount();
								//	输出列名
						%>
						<tr>
						<%
						for (int i = 1; i <= columnCount; i++) {
						%>
						<td><%=rsmd.getColumnName(i)%></td>
						<%
							}
						%>
					</tr>
					<br />
						<%
						while (rs.next()) {
						%>
						<tr>
						<%
						for (int j = 1; j <= columnCount; j++) {
						%>
						<td><%=rs.getObject(j)%></td>
						<%
						}%>
						</tr>
						<%
						}
						rs.close();
						stmt.close();				
						conn.close();
						} else {
							int num = stmt.getUpdateCount();
						%>
						<table border="2" bgcolor="white" width="80%" align="center" cellspacing="1px" cellpadding="1px">
							<tr>
								<td>The query has affected <%=num%>records!</td>
								<br /> <br /> <br /> <br /> <br /> <br />
							</tr>
						</table>
						<%
						stmt.close();	
						conn.close();
						}
				}catch (SQLException e) {
					System.out.println("Wrong syntax!");
					e.printStackTrace();
				%>
			<table border="2" bgcolor="white" width="80%" height="300" align="center" cellspacing="1px" cellpadding="1px">
			<tr>
				<td>Error! Worng syntax!</td>
			</tr>
			</table>
			<%	} catch (Exception e) {
					e.printStackTrace();
				}	%>
	</table>
	<% } %>
</body>
</html>