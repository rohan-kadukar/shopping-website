package shopping;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logout(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logout(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Get the current session, do not create a new one
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Invalidate the session to log out the user
            session.invalidate();
        }
        // Redirect to the index page after logout
        response.sendRedirect("index.jsp"); // Change this to your desired redirect page if necessary
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet";
    }
}
