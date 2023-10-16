<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Feedback Page</title>
  <link rel="stylesheet" href="mystyle.css">
  <style>
    label {
      display: block;
      margin-top: 5px;
    }
    input[type="text"]
    input[type="email"], textarea {
      width: 200px;
	}
	
     input[type="radio"] {
    width: 30px;
    height: 30px;
  }
	button {
  width: 100px;
  height: 40px;
  font-size: 30px;
  margin-top: 10px;
}

	input[type="text"], input[type="email"], textarea {
    width: 450px; /* Decreased the width of text fields */
    height: 40px;
    padding: 2px;
    border-radius: 10px; /* Added round border */
  }
    
    input[type="submit"] {
      margin-top: 10px;
	font-size: 30px;
    }
	::placeholder {
    font-size: 30px;
  }
  </style>
<script>
  function populateFeedback() {
    var radios = document.getElementsByName('n');
    var feedbackField = document.getElementById('feedback');

    for (var i = 0; i < radios.length; i++) {
      if (radios[i].checked) {
        feedbackField.value = radios[i].value;
        break;
      }
    }
  }
function goBack() {
      window.location.href = "home1.jsp";
    }

 function showCustomValidity(element, message) {
      element.setCustomValidity(message);
      element.reportValidity();
    }

    function clearCustomValidity(element) {
      element.setCustomValidity('');
    }
</script>


</head>
<body>
<center>
  <h1> Student Feedback </h1>
  <form>
    <label for="rno">Enter Roll No:</label>
    <input type="text" id="rno" name="rno" placeholder="Enter Roll number" required pattern="\d+" 
           oninvalid="this.value === '' ? showCustomValidity(this, 'Roll No cannot be empty.') : showCustomValidity(this, 'Only numbers allowed.')"
           oninput="clearCustomValidity(this)">

    <label for="name">Enter Name:</label>
    <input type="text" id="name" name="name" placeholder = "Enter Name" required pattern="[A-Za-z\s]+" 
	 oninvalid="showCustomValidity(this, 'Only alphabets allowed.')"
           oninput="clearCustomValidity(this)">

    <label for="email">Enter Email:</label>
    <input type="email" id="email" name="email" placeholder = "Enter Email" required>
	
    <label for="feedback">Feedback For Institute:</label>
	<label for="rating" style="font-size: 30px;">5 is for excellent</label>
   <input type = "hidden" id = "feedback" name="feedback" placeholder="5 is for Excellent" required> 
	
        <input type="radio" name="n" value="1" onchange="populateFeedback()">1
	<input type="radio" name="n" value="2" onchange="populateFeedback()">2
	<input type="radio" name="n" value="3" onchange="populateFeedback()">3
	<input type="radio" name="n" value="4" onchange="populateFeedback()">4
	<input type="radio" name="n" value="5" onchange="populateFeedback()">5
<br>
<input type="submit" value="Submit Feedback" name = "btn">
<button type="button" onclick="goBack()">Back</button>
</form>

<%
if (request.getParameter("btn") != null)
	{

	try
	{
		int rno = Integer.parseInt(request.getParameter("rno"));
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		int feedback = Integer.parseInt(request.getParameter("feedback"));
		
		DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());	
		String url = "jdbc:mysql://localhost:3306/au_23june";
		Connection  con = DriverManager.getConnection(url,"root","abc456");
		 String checkSql = "SELECT * FROM feedback1 WHERE rno=?";
    	PreparedStatement checkPst = con.prepareStatement(checkSql);
    	checkPst.setInt(1, rno);
    	ResultSet checkResult = checkPst.executeQuery();
    
    	if (checkResult.next()) {
     	 // Feedback already exists for the given roll number
      	out.println("Feedback already submitted for Roll No: " + rno);
    	} 	else {
		String sql = "insert into feedback1 values (?,?,?,?)";
		PreparedStatement pst = con.prepareStatement(sql);
		pst.setInt(1,rno);
		pst.setString (2,name);
		pst.setString(3,email);
		pst.setInt(4,feedback);
		pst.executeUpdate(); 	
		con.close();
		out.println("Feedback submitted successfully!");
		}
		

	}catch(SQLException e)
		{
			out.println("issue" + e);
		}
	}

%>
</center>
</body>
</html>
