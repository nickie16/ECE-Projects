	<?php	
		$con = mysqli_connect("localhost:3306","root","","project");
		if (mysqli_connect_errno())
		{
			die('Could not connect: ' . mysqli_error($con));
		}

		$BId=$_GET['BId'];
		$LId=$_GET['LId'];
		$Percentage=$_GET['Percentage'];
		if ($BId==='' or $LId==='' or $Percentage==='') {header('Location:Trust-Update.html');exit;}
	
		$result = mysqli_query($con, "UPDATE trust SET Percentage=$Percentage WHERE BId=$BId AND LId=$LId");
		
		if($result === FALSE) { 
			die(mysqli_error($con)); 
		}
		mysqli_close($con);
		
	?>	
	
<html style="background-color:#f8f0e2;">
<head>
	<title>Redirecting</title>
</head>
<body>
		<meta http-equiv="refresh" content="2; url=main.html" />
		<h1 align="center" style="color:darkred;font-size=200px;font-family:Lucida Handwriting;"><strong>Redirecting you in 3 seconds...</strong></h1>
</body>
</html>