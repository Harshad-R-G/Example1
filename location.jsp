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

        // Function to get the user's geolocation
        function fetchGeolocation() {
            return new Promise((resolve, reject) => {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        (position) => {
                            const { latitude, longitude } = position.coords;
                            resolve({ latitude, longitude });
                        },
                        (error) => {
                            reject(error.message);
                        }
                    );
                } else {
                    reject("Geolocation not supported by this browser.");
                }
            });
        }

        // Define the classroom boundaries
        const classroomBounds = {
            north: 19.971200, // Maximum latitude
            south: 19.971171, // Minimum latitude
            east: 73.719880,  // Maximum longitude
            west: 73.719807   // Minimum longitude
        };

        // Function to check if the location is inside the classroom
        function isLocationInsideClassroom(latitude, longitude, bounds) {
            return (
                latitude >= bounds.south &&
                latitude <= bounds.north &&
                longitude >= bounds.west &&
                longitude <= bounds.east
            );
        }

        window.onload = async function () {
            const studentId = getUrlParameter("student_id");
            const studentIdDisplay = document.getElementById("studentId");
            const locationDisplay = document.getElementById("location");
            const ipDisplay = document.getElementById("ipAddress");

            if (studentId) {
                studentIdDisplay.innerText = "Student ID: " + decodeURIComponent(studentId);

                // Get geolocation
                try {
                    const location = await fetchGeolocation();
                    const { latitude, longitude } = location;

                    // Check if the location is inside the classroom
                    if (isLocationInsideClassroom(latitude, longitude, classroomBounds)) {
                        locationDisplay.innerText = `Location: Latitude ${latitude}, Longitude ${longitude} (Inside classroom)`;

                        alert("You are inside the classroom");
                        // Send student ID, location, and mark attendance
                        /* const response = await fetch("MarkAttendanceServlet", {
                            method: "POST",
                            headers: { "Content-Type": "application/json" },
                            body: JSON.stringify({
                                student_id: studentId,
                                latitude: latitude,
                                longitude: longitude,
                            }),
                        });
                        const serverResponse = await response.text();
                        console.log(serverResponse); */
                    } else {
                        locationDisplay.innerText = `Location: Latitude ${latitude}, Longitude ${longitude} (Outside classroom)`;
                        alert("You are outside the classroom boundary. Attendance cannot be marked.");
                    }
                } catch (error) {
                    locationDisplay.innerText = "Location: Unable to fetch location (" + error + ")";
                }

                // Fetch client IP address
                fetch("GetClientIPServlet")
                    .then(response => response.text())
                    .then(ip => {
                        ipDisplay.innerText = "IP Address: " + ip;
                    });
            } else {
                studentIdDisplay.innerText = "No student ID found!";
            }
        };
    </script>
</head>
<body>
    <h1>Attendance Marking</h1>
    <p id="studentId">Fetching your details...</p>
    <p id="location">Fetching your location...</p>
    <p id="ipAddress">Fetching your IP address...</p>
</body>
</html>
