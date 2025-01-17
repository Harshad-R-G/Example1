<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
    <title>Attendance Marking</title>
    <script>
        // Function to get the query parameter from the URL
        function getUrlParameter(name) {
            const params = new URLSearchParams(window.location.search);
            return params.get(name);
        }

        window.onload = function () {
            const studentId = getUrlParameter("student_id");
            if (studentId) {
                document.getElementById("studentId").innerText = "Student ID: " + decodeURIComponent(studentId);
                // Optionally send the student ID to the server for attendance marking
                fetch("MarkAttendanceServlet", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ student_id: studentId })
                }).then(response => response.text()).then(data => {
                    console.log(data);
                });
            } else {
                document.getElementById("studentId").innerText = "No student ID found!";
            }
        };
    </script>
</head>
<body>
    <h1>Attendance Marking</h1>
    <p id="studentId">Fetching your details...</p>
</body>
</html>
